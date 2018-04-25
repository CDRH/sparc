class ExploreController < ApplicationController
  before_action :set_section
  before_action :get_unit
  skip_before_action :get_unit, only: [:units, :zone], raise: false

  def index
  end

  def map
    @subsection = "map"
  end

  def units
    @subsection = "units"
    @unit_occs = Occupation.includes(:units)
                   .where.not(units: { occupation_id: nil })
                   .sorted

    units = Unit.includes(
      :inferred_function,
      :type_description,
      :occupation,
    )

    # text searches
    units = units.where("unit_no LIKE ?", "%#{params['unit_no']}%") if params["unit_no"].present?
    units = units.where("other_description LIKE ?", "%#{params['other_description']}%") if params["other_description"].present?
    units = units.where("units.comments LIKE ?", "%#{params['comments']}%") if params["comments"].present?
    units = units.joins(:strata).where("strata.strat_all LIKE ?", "%#{params['strata']}%") if params["strata"].present?

    # basic joins
    units = add_to_query(units, :excavation_statuses, params["excavation_status"], :excavation_status)
    units = add_to_query(units, :inferred_functions, params["inferred_function"], :inferred_function, false)
    units = add_to_query(units, :intact_roofs, params["intact_roof"], :intact_roof)
    units = add_to_query(units, :irregular_shapes, params["irregular_shape"], :irregular_shape)
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

  def unit_associated
    @subsection = "units"
    @selected = "associated"

    @associated = {
      "samples" => {
        "pollens" => ["pollen_inventory"],
        "soils" => ["soil"],
        "tree_rings" => ["tree_ring"]
      },
      "artifacts" => {
        "ceramics" => ["ceramic_inventory", "ceramic_clap", "ceramic",
                "ceramic_vessel"],
        "eggshells" => ["eggshell"],
        "faunal" => ["bone_tool", "faunal_artifacts", "faunal_inventory"],
        "lithics" => ["lithic_inventory", "lithic_debitage", "lithic_tool",
          "obsidian_inventories"],
        "ornaments" => ["ornament"],
        "perishables" => ["perishable"],
        "woods" => ["wood_inventory"]
      }
    }
  end

  def unit_documents
    @subsection = "units"
    @selected = "documents"

    @res = []

    doc_types = @unit.document_types.pluck(:id)
    doc_types.each do |dt|
      @res << Document.joins(:document_type, :units)
              .where("units.unit_no = ?", @unit.unit_no)
              .where(document_type: dt)
              .sorted
              .first
    end
    @document_count = @unit.documents.count
  end

  def unit_images
    @subsection = "units"
    @selected = "images"
    @unit = Unit.find_by(unit_no: params["number"])
    @images = @unit.images
    @images_display = @images.sorted.limit(8)
  end

  def unit_overview
    @subsection = "units"
    @selected = "overview"
  end

  def unit_strata
    @subsection = "units"
    @selected = "strata"

    @strata = @unit.strata.includes(:features, :occupation, :strat_type)
  end

  def unit_summary
    @subsection = "units"
    @selected = "summary"
  end

  def zone
    @subsection = "units"
    # pad zones with appropriate number of zeroes, despite P / BW codes
    @zone_no = params["number"].rjust(3, "0")
    if @zone_no[/[A-Z]/]
      num = @zone_no[/\d*/]
      if num.length < 3
        @zone_no = @zone_no.gsub(num, num.rjust(3, "0"))
      end
    end
    @zone = Zone.find_by(name: @zone_no)
    if @zone
      @units = @zone.units.sorted
      # if linked to from the chaco occupation map, filter the units
      @all_count = @units.count
      if params["occupation"] == "chaco"
        @units = @units.joins(:occupation)
          .where("occupations.name": ["Chacoan", "Mixed Chacoan and San Juan"])
        @is_filtered = @all_count != @units.count
      end
    end
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

  def get_unit
    @unit = Unit.sorted.where(unit_no: params["number"]).first
  end

  def set_section
    @section = "explore"
  end
end
