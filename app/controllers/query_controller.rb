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
        count: table.classify.constantize.count
      }
    end

    params[:table] =
      params[:table].present? ? params[:table] : @tables.first[:name]

    @table_class = params[:table].to_s.classify.constantize
    @table_fields = collect_fields @table_class
    @subsection = table_label
  end

  def results
    params.require([:category, :subcat, :table])
    @subsection = table_label

    @table = params[:table].classify.constantize
    @table_fields = collect_fields @table

    # Flatten primary and other field hash sets into one array of field hashes
    @table_fields = %i[primary other].map { |set| @table_fields[set] }.flatten

    res = search_fields @table, @table_fields

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
          columns: @column_names
      }
    end
  end

  private

  def common_search(res)
    # Save params in session
    session[:common_search_unit] = params["unit"]
    session[:common_search_unit_class] = params["unit_class"]
    session[:common_search_occupation] = params["occupation"]
    session[:common_search_strat_grouping] = params["strat_grouping"]
    session[:common_search_feature_group] = params["feature_group"]

    # Units
    if (params["unit"].present? || params["unit_class"].present?)
      assocs = res.reflect_on_all_associations.map { |a| a.name }
      if assocs.include?(:units)
        res = res.joins(:units)

        if params["unit"].present?
          res = res.where(units: { id: params["unit"] })
        end

        if params["unit_class"].present?
          res = res.where(units: { unit_class_id: params["unit_class"] })
        end
      elsif assocs.include?(:unit)
        if params["unit"].present?
          res = res.where(unit_id: params["unit"])
        end

        if params["unit_class"].present?
          res = res.where(unit_id:
            UnitClass.where(id: params["unit_class"]).pluck(:id))
        end
      end
    end

    # Occupations
    if params["occupation"].present?
      assoc_name_list = res.reflect_on_all_associations.map { |a| a.name }

      # Filter by occupation based on occupation of associated strata,
      # noted as more accurate than tables' own occupation data
      if assoc_name_list.include?(:strata)
        res = res.select("#{@table.to_s.tableize}.*, strata.occupation_id")
                .joins(:strata)
                .where(strata: { occupation_id: params["occupation"] })
        @occupation_source = "Strat Occupation"
      elsif assoc_name_list.include?(:occupation)
        res = res.where(occupation_id: params["occupation"])
        @occupation_source = "#{@table.to_s.titleize} Occupation"
      elsif assoc_name_list.include?(:occupations)
        res = res.select("#{@table.to_s.tableize}.*, features.occupation_id")
                .joins(:features)
                .where(occupations: { id: params["occupation"] })
        @occupation_source = "#{@table.to_s.titleize} Occupations"
      end
    end

    # Strat Types
    if params["strat_grouping"].present? \
    && res.reflect_on_all_associations.map { |a| a.name }.include?(:strata)
      res = res.joins(strata: [strat_type: [:strat_grouping]])
              .where(strat_groupings: { id: params["strat_grouping"] })
    end

    # Feature Groups
    if params["feature_group"].present?
      if res.reflect_on_all_associations.map { |a| a.name }
           .include?(:features)
        res = res.joins(features: [:feature_group])
                .where(feature_groups: { id: params["feature_group"] })
      elsif res.reflect_on_all_associations.map { |a| a.name }
              .include?(:strata)
        res = res.joins(strata: [features: [:feature_group]])
                .where(feature_groups: { id: params["feature_group"] }).uniq
      end
    end

    res
  end

  def set_section
    @section = "query"
  end
end
