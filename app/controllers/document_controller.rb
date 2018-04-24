require 'iiif/presentation'

class DocumentController < ApplicationController
  before_action :set_section

  def index
    # filter out units with no documents
    @units = Unit.includes(:documents).where.not(documents: { id: nil }).sorted
    @units_no_docs = Unit.includes(:documents).where(documents: { id: nil }).sorted
  end

  def unit
    @unit_no = params["unit"]
    @unit = Unit.find_by(unit_no: @unit_no)
    @first_doc_type = nil
    # if document type is known, then skip building collections
    if params["type"].present?
      @res = build_manifest(@unit, params["type"])
    else
      @res = build_collection(@unit)
    end

    respond_to do |format|
      format.html
      format.json { render json: @res }
    end
  end

  private

  def build_collection(unit)
    unit_no = unit.unit_no
    collections = {}
    DocumentType.all.each_with_index do |dt, idx|
      key = dt.name.parameterize(separator: "_")
      docs = Document.joins(:document_type, :units)
              .where("units.unit_no = ?", unit_no)
              .where(document_type: dt)
              .sorted
      if docs.count > 0
        collections[key] = docs
      end
    end

    collection_url = documents_unit_path({ unit: unit_no })
    wrapper = IIIF::Presentation::Collection.new("@id" => collection_url)
    collection = IIIF::Presentation::Collection.new(
                   "@id" => collection_url,
                   "@label" => unit_no
                 )
    collections.each do |doc_type, docs|
      manifest = IIIF::Presentation::Manifest.new(
                   "@id" => documents_unit_path({
                      unit: unit_no,
                      type: doc_type,
                      format: "json"
                    }),
                    "label" => get_doc_type_name(doc_type),
                    "metadata" => [
                      "label" => "Unit",
                      "value" => unit_no
                    ],
                    "viewing_hint" => "paged"
                  )
      collection.manifests <<  manifest
    end

    wrapper.collections << collection
    wrapper.to_json
  end

  def build_manifest(unit, type)
    unit_no = unit.unit_no
    title_link = unit_no.parameterize(separator: "_")
    room_type = unit.unit_class.name.titleize

    # get documents to display using document type name
    type_name = get_doc_type_name(type)
    doc_type = DocumentType.find_by(name: type_name)
    res = Document.joins(:document_type, :units)
            .where("units.unit_no = ?", unit_no)
            .where("document_types.name = ?", type_name)
            .sorted

    # build the manifest for a requested document type
    manifest = IIIF::Presentation::Manifest.new(
                 "@id" => documents_unit_path({ unit: title_link }),
                 "metadata" => [{
                   "label" => "Unit",
                   "value" => "#{unit_no}"
                 }],
                 "viewing_hint" => "paged"
               )

    manifest.label = "#{room_type} #{unit_no} #{doc_type.name}"

    # create a sequence of canvases to add to the manifest
    sequence = IIIF::Presentation::Sequence.new
    num = 0

    # create canvases
    res.each do |result|
      room_type = unit.unit_class.code
      num += 1

      img_info = {
        "label" => "Page #{num}",
        "page" => "#{result.page_id}",
        "creator" => result.scan_creator,
        "rights" => result.rights
      }
      sequence.canvases << image_annotation_from_id(unit_no, doc_type, result.filepath, img_info)
    end

    manifest.sequences << sequence

    thumb = sequence.canvases.first.images.first.resource['@id']
    manifest.insert_after(existing_key: 'label', new_key: 'thumbnail', value: thumb)
    manifest.to_json
  end

  def image_annotation_from_id(unit_no, doc_type, image_id, image_info)
    annotation = IIIF::Presentation::Annotation.new
    annotation.resource = image_resource_from_page_hash(image_id)
    canvas = IIIF::Presentation::Canvas.new
    doc_type_url = doc_type.name.parameterize(separator: "_")
    uri = "#{request.base_url}/documents/unit/#{unit_no}/#{doc_type_url}.json"
    canvas['@id'] = uri
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
    base_uri = "#{SETTINGS["iiif_server"]}%2F#{page_id.gsub('/','%2F')}"
    opts = { service_id: base_uri }
    begin
      image_resource = IIIF::Presentation::ImageResource.create_image_api_image_resource(opts)
    rescue
      base_uri = "#{SETTINGS["iiif_server"]}%2Fnot_found.jpg"
      opts = { service_id: base_uri }
      image_resource = IIIF::Presentation::ImageResource.create_image_api_image_resource(opts)
    end
    image_resource
  end

  def set_section
    @section = "documents"
  end

end
