require_relative "../renderers/csv.rb"

class QueryController < ApplicationController
  include ActiveRecordAbstraction
  before_action :set_section

  def category
    params.require(:category)
    @subsection = params[:category]

    if ABSTRACT["nav"][params[:category]]["singular"]
      # These are lone tables, so call the form action and render its view
      params[:subcat] = params[:category]
      form
      render :form
    end
  end

  def form
    params.require([:category, :subcat])

    # Clear common search options
    if params["search_clear"].present?
      session[:common_search_unit] = nil
      session[:common_search_unit_class] = nil
      session[:common_search_occupation] = nil
      session[:common_search_strat_grouping] = nil
      session[:common_search_feature_group] = nil
    end

    category = ABSTRACT["nav"][params[:category]]
    if category["singular"]
      @tables = { params[:category] => category }
    else
      subcat = category[params[:subcat]]
      if subcat["singular"]
        @tables = { params[:subcat] => subcat }
      else
        @tables = subcat
      end
    end

    @tables = @tables.map do |table, info|
      {
        name: table,
        label: info && info["label"].present? ? info["label"] : table.titleize,
        count: table.classify.constantize.unscoped.count
      }
    end

    params[:table] =
      params[:table].present? ? params[:table] : @tables.first[:name]

    @table_class = params[:table].to_s.classify.constantize
    @table_fields = collect_fields(@table_class)
    @subsection = table_label
  end

  def other
    respond_to do |format|
      format.csv {
        @table_fields = collect_fields(SelectArtifact)
        @table_fields = %i[primary other].map { |set| @table_fields[set] }.flatten
        res = search_fields(SelectArtifact, @table_fields)

        render csv: res.sorted,
          filename: "select_artifacts",
          occupation_source: nil,
          table_fields: @table_fields
      }
      format.html { }
    end
  end

  def results
    params.require([:category, :subcat, :table])
    @subsection = table_label

    @table = params[:table].classify.constantize
    @table_fields = collect_fields(@table)

    # Flatten primary and other field hash sets into one array of field hashes
    @table_fields = %i[primary other].map { |set| @table_fields[set] }.flatten

    res = search_fields(@table, @table_fields)

    # Handle common search fields
    res = common_search res
    respond_to do |format|
      format.html {
        @res = res.sorted.paginate(page: params[:page], per_page: 20)
      }
      format.csv {
        render csv: res.sorted,
          filename: params["all"] ? params[:table] :
            "#{params[:table]}_search_results",
          occupation_source: @occupation_source,
          table_fields: @table_fields
      }
    end
  end

  private

#  def add_occupation_field(association)
#    if @table_fields.select { |f| f[:name].include?("occupation") }.empty?
#      if association == :strata
#        @table_fields.unshift({ assoc: :unknown, name: "occupation" })
#      elsif association == :occupations
#        @table_fields.unshift({ assoc: :unknown, name: "occupations" })
#      elsif association == :occupation
#        @table_fields.unshift({ assoc: :unknown, name: "occupation" })
#      end
#    end
#  end

  def add_unit_field(association)
    if @table_fields.select { |f| f[:name].include?("unit") }.empty?
      if association == :units
        @table_fields.unshift({ assoc: :unknown, name: "units" })
      elsif association == :unit
        @table_fields.unshift({ assoc: :unknown, name: "unit" })
      end
    end
  end

  def common_search(res)
    # Save params in session
    session[:common_search_unit] = params["unit_common"]
    session[:common_search_unit_class] = params["unit_class_common"]
    session[:common_search_occupation] = params["occupation_common"]
    session[:common_search_strat_grouping] = params["strat_grouping"]
    session[:common_search_feature_group] = params["feature_group_common"]

    # Units
    if (params["unit_common"].present? || params["unit_class_common"].present?)
      assocs = res.reflect_on_all_associations.map { |a| a.name }
      if @table == Unit
        if params["unit_common"].present?
          res = res.where(id: params["unit_common"])
        end

        if params["unit_class_common"].present?
          res = res.where(unit_class_id: params["unit_class_common"])
        end
      elsif assocs.include?(:units)
        add_unit_field(:units)
        res = res.joins(:units)

        if params["unit_common"].present?
          res = res.where(units: { id: params["unit_common"] })
        end

        if params["unit_class_common"].present?
          res = res.where(units: { unit_class_id: params["unit_class_common"] })
        end
      elsif assocs.include?(:unit)
        add_unit_field(:unit)

        if params["unit_common"].present?
          if !@table.columns.map { |c| c.name.to_s }.include?("unit_id")
            # Handles TreeRing search with Unit Number
            res = res.where(unit_no: Unit.select(:unit_no)
              .where(id: params["unit_common"]))
          else
            res = res.where(unit_id: params["unit_common"])
          end
        end

        if params["unit_class_common"].present?
          if !@table.columns.map { |c| c.name.to_s }.include?("unit_id")
            # Handles TreeRing search with Unit Class
            res = res.where(unit_no:
              Unit.select(:unit_no).where(unit_class_id:
                UnitClass.where(id: params["unit_class_common"])
              )
            )
          else
            res = res.where(unit_id:
              UnitClass.where(id: params["unit_class_common"]).pluck(:id))
          end
        end
      end
    end

    # Occupations
    if params["occupation_common"].present?
      assoc_name_list = res.reflect_on_all_associations.map { |a| a.name }

      # Filter by occupation based on occupation of associated strata,
      # noted as more accurate than tables' own occupation data
      if assoc_name_list.include?(:strata) &&
        !%w[Unit Feature].include?(res.model_name.name)

        res = res.select("#{@table.to_s.tableize}.*, strata.occupation_id")
                .joins(:strata)
                .where(strata: { occupation_id: params["occupation_common"] })
        @occupation_source = "Strat Occupation"
#        add_occupation_field(:strata)
      elsif assoc_name_list.include?(:occupation)
        res = res.where(occupation_id: params["occupation_common"])
        @occupation_source = "#{@table.to_s.titleize} Occupation"
#        add_occupation_field(:occupation)
      elsif assoc_name_list.include?(:occupations)
        res = res.select("#{@table.to_s.tableize}.*, features.occupation_id")
                .joins(:features)
                .where(occupations: { id: params["occupation_common"] })
        @occupation_source = "#{@table.to_s.titleize} Occupations"
#        add_occupation_field(:occupations)
      end
    end

    # Strat Types
    if params["strat_grouping"].present?
      if res.reflect_on_all_associations.map { |a| a.name }.include?(:strata) &&
        !%w[CeramicClap Unit].include?(res.model_name.name)
        # Disable tables returning more results than they have records
        # until separate issue causing that is fixed

        res = res.joins(strata: [strat_type: [:strat_grouping]])
          .where(strat_groupings: { id: params["strat_grouping"] })
      elsif res.reflect_on_all_associations.map { |a| a.name }
        .include?(:stratum)

        res = res.joins(stratum: [strat_type: [:strat_grouping]])
          .where(strat_groupings: { id: params["strat_grouping"] })
      elsif res.reflect_on_all_associations.map { |a| a.name }
        .include?(:strat_grouping)

        res = res.joins(:strat_type).where(strat_type: StratGrouping.where(id: params["strat_grouping"]))
      end
    end

    # Feature Groups
    if params["feature_group_common"].present?
      if res.reflect_on_all_associations.map { |a| a.name }
        .include?(:features) && res.model_name.name != "Unit"

        res = res.joins(features: [:feature_group])
          .where(feature_groups: { id: params["feature_group_common"] })
      elsif res.reflect_on_all_associations.map { |a| a.name }.include?(:strata)
        res = res.joins(strata: [features: [:feature_group]])
          .where(feature_groups: { id: params["feature_group_common"] }).uniq
      elsif res.reflect_on_all_associations.map { |a| a.name }
        .include?(:stratum)

        res = res.joins(stratum: [features: [:feature_group]])
          .where(feature_groups: { id: params["feature_group_common"] }).uniq
      end
    end

    res
  end

  def set_section
    @section = "query"
  end
end
