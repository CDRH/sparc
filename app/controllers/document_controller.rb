class DocumentController < ApplicationController

  def index
    # filter out units with no documents
    @units = Unit.includes(:documents).where.not(documents: { id: nil }).sorted

    @units_no_docs = Unit.includes(:documents).where(documents: { id: nil }).sorted
  end

  def type
    @type = params["type"]
    type_name = get_doc_type_name(@type)
    res = Document.joins(:document_type).where("document_types.name = ?", type_name)
    @result_num = res.size
    @res = res.paginate(page: params[:page], per_page: 20)
  end

  def unit
    @unit = params["unit"]
    @type = nil
    @collections = {}
    @first_doc_type = nil
    if params["type"].present?
      @type = params["type"]
    else
      @type = DocumentType.joins(:units)
                .where(units: {unit_no: @unit}).sorted.first
                .name.parameterize(separator: "_")
      DocumentType.all.each do |dt|
        units = DocumentType.joins(:units).where(units: {unit_no: @unit}, name: dt.name).size
        if units > 0
          @collections[dt.name.parameterize(separator: "_")] = Document.joins(:document_type, :units)
            .where("units.unit_no = ?", @unit)
            .where("document_types.name = ?", dt.name)
            .sorted
          end
          @first_doc_type = @collections[@collections.keys.first].first.document_type.name if @collections[@collections.keys.first]
      end
    end

    type_name = get_doc_type_name(@type)
    
    @collections.each {|k,v| puts "#{k} = #{v.size}"}
    res = Document.joins(:document_type, :units)
            .where("units.unit_no = ?", @unit)
            .where("document_types.name = ?", type_name)
            .sorted
            
    @result_num_docs = res.size
    @res = res.paginate(page: params[:page], per_page: 20)

    # generate the color coded document type buttons
    possible_types = DocumentType.joins(:units)
                      .where("units.unit_no = ?", @unit).uniq
    @group_colors = possible_types.sorted.group_by(&:color)
    
    code = params['code'].present? ? params['code'] : nil

    respond_to do |format|
        format.html
        format.json { render :json => (@collections.size > 0 ? build_collection(@collections, @unit) : build_manifest(res, code)) }
      end
  end
  
  private
  
  require 'iiif/presentation'

  def image_annotation_from_id(title, image_id, image_info)
    annotation = IIIF::Presentation::Annotation.new
    annotation.resource = image_resource_from_page_hash(image_id)
    canvas = IIIF::Presentation::Canvas.new
    # TODO what should this URL be? Use parameterize for title
    canvas_uri = "http://example.org/#{title.gsub(' ','_')}/pages/#{image_id}"
    canvas['@id'] = canvas_uri
    canvas.label = image_info['label']
    canvas.width = annotation.resource['width']
    canvas.height = annotation.resource['height']
    canvas.images << annotation
    canvas.metadata = [
      { 'label' => 'Page ID',
        'value' => image_info['page']
      },
      { 'label' => 'Creator', 
        'value' => image_info['creator']
      },
      { 'label' => 'Rights', 
        'value' => image_info['rights']
      }
    ]
    canvas
  end

  def image_resource_from_page_hash(page_id)
    base_uri = "#{SETTINGS["iiif_server"]}#{page_id.gsub('/','%2F')}"
    params = {service_id: base_uri}
    begin
      image_resource = IIIF::Presentation::ImageResource.create_image_api_image_resource(params)
    rescue
      base_uri = "#{SETTINGS["iiif_server"].gsub('sparc','coming_soon.jpg')}"
      params = {service_id: base_uri}
      image_resource = IIIF::Presentation::ImageResource.create_image_api_image_resource(params)
    end      
    image_resource
  end

  def build_collection(collection_hash, unit)
    wrapper = IIIF::Presentation::Collection.new('@id' => documents_unit_path({unit: unit}))
    collection = IIIF::Presentation::Collection.new('@id' => documents_unit_path({unit: unit}), '@label' => unit)
    collection_hash.each do |k, docs|
      
      unit = docs.first.units.first
      title = unit.unit_no
      manifest = IIIF::Presentation::Manifest.new('@id' => documents_unit_path({unit: title, type: k, format: "json"}))
      manifest.label = k.humanize 
      manifest.viewing_hint = 'paged'
      manifest.metadata = [
        { 'label' => 'Unit', 'value' => "#{title.split('-').first}" }
      ]

      collection.manifests <<  manifest
    end
  
    wrapper.collections << collection
    wrapper.to_json(pretty: true)
  end

  def build_manifest(results, code)
    first_doc = results.first
    unit = Unit.find_by(unit_no: first_doc.canonical_unit_no)
    title = unit.unit_no
    manifest = IIIF::Presentation::Manifest.new('@id' => "http://example.org/#{title.gsub(' ','_')}")
    room_type = unit.unit_class.name.titleize

    # document type
    code = first_doc.page_id.split('_')[1]
    doc_type = DocumentType.find_by(code: code)
    manifest.label = "#{room_type} #{title.split('-').first} #{doc_type}"
    manifest.viewing_hint = 'paged'
    manifest.metadata = [
      { 'label' => 'Unit', 'value' => "#{title}" },
    ]

    sequence = IIIF::Presentation::Sequence.new
    num = 0

    results.each do |result|
      room_type = unit.unit_class.code
      doc_type = result.document_type ? result.document_type.code : "na"
      num += 1

      img_info = {
        "label" => "Page #{num}",
        "page" => "#{result.page_id}",
        "creator" => result.scan_creator,
        "rights" => result.rights
      }
      sequence.canvases << image_annotation_from_id(title, result.path, img_info)
    end

    manifest.sequences << sequence

    thumb = manifest.sequences.first.canvases.first.images.first.resource['@id']
    manifest.insert_after(existing_key: 'label', new_key: 'thumbnail', value: thumb)

    manifest.to_json(pretty: true)
  end

end
