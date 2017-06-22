class ExploreController < ApplicationController

  def units
    units = Unit.includes(
      :inferred_function,
      :type_description,
      :occupation,
    )

    # text searches
    units = units.where("unit_no LIKE ?", "%#{params['unit_no']}%") if !params["unit_no"].blank?
    units = units.where("other_description LIKE ?", "%#{params['other_description']}%") if !params["other_description"].blank?
    units = units.where("comments LIKE ?", "%#{params['comments']}%") if !params["comments"].blank?
    units = units.joins(:strata).where("strata.strat_all LIKE ?", "%#{params['strata']}%") if !params["strata"].blank?

    # basic joins
    units = add_to_query(units, :excavation_statuses, params["excavation_status"], :excavation_status)
    units = add_to_query(units, :inferred_functions, params["inferred_function"], :inferred_function, false)
    units = add_to_query(units, :intact_roofs, params["intact_roof"], :intact_roof)
    units = add_to_query(units, :irregular_shapes, params["irregular_shape"], :irregular_shape)
    units = add_to_query(units, :room_types, params["room_type"], :room_type)
    units = add_to_query(units, :salmon_sectors, params["salmon_sector"], :salmon_sector)
    units = add_to_query(units, :stories, params["story"], :story)
    units = add_to_query(units, :type_descriptions, params["type_description"], :type_description, false)
    units = add_to_query(units, :unit_classes, params["unit_class"], :unit_class)
    units = add_to_query(units, :occupations, params["occupation"], :occupation, false)
    units = add_to_query(units, :zones, params["zone"], :zone)

    # left joins where not null
    if params["items"].present?
      params["items"].each do |item|
        units = units.includes(item).where.not(item => { :id => nil })
      end
    end

    @result_num = units.size
    @units = units.sorted.paginate(:page => params[:page], :per_page => 20)
  end

  def unit
    @unit = Unit.sorted.where(:unit_no => params["number"]).first
    @images = Image.sorted.joins(:units).where(:units => { :unit_no => params["number"] }).limit(8)

    # documents

    if params["type"].present?
      @type = params["type"]
    else
      doc_types = DocumentType.joins(:units)
                    .where(units: {unit_no: @unit.unit_no}).sorted.first
      @type = doc_types.name.parameterize("_") if doc_types
    end

    type_name = get_doc_type_name(@type)
    res = Document.joins(:document_type, :units)
            .where("units.unit_no = ?", @unit.unit_no)
            .where("document_types.name = ?", type_name)
            .sorted
    @result_num_docs = res.size
    @res = res.paginate(page: params[:page], per_page: 20)

    # generate the color coded document type buttons
    possible_types = DocumentType.joins(:units).where("units.id = ?", @unit.id).uniq
    @group_colors = possible_types.sorted.group_by(&:color)
  end

  def zone
    @units = Unit.sorted.joins(:zone).where("zones.number" => params["number"])
  end


  private

  # TODO combine this with the images search when the branches are merged
  # essentially creating: images.where(:where_rel => { :id => param }).joins(:relationship)
  # most of the time relationship is the same as where_rel but depends on model design
  def add_to_query query_obj, where_rel, param, relationship=where_rel, joins=true
    if param.present?
      query_obj = query_obj.where(where_rel => { :id => param })
      query_obj = query_obj.joins(relationship) if joins
    end
    return query_obj
  end
end
