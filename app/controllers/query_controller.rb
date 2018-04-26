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
    @table_inputs = table_input_columns(@table_class)
    @table_selects = table_select_columns(@table_class)
    @subsection = table_label
  end

  def results
    params.require([:category, :subcat, :table])
    @subsection = table_label

    @table = params[:table].classify.constantize
    @column_names = @table.columns.reject { |c| c.name[/(?:^id|_at)$/] }
      .map(&:name)
    res = @table

    inputs = table_input_columns(@table)
    inputs.each do |column|
      if params[column[:name]].present?
        if column[:type] == "string"
          res = res.where("#{column[:name]} LIKE ?",
                            "%#{params[column[:name]]}%")
        else
          res = res.where("#{column[:name]} = ?", params[column[:name]])
        end
      end
    end

    bt_columns =
      @table.reflect_on_all_associations(:belongs_to).map { |a| a.name.to_s }
    habtm_columns =
      @table.reflect_on_all_associations(:has_and_belongs_to_many)
        .map { |a| a.name.to_s }
    hm_columns =
      @table.reflect_on_all_associations(:has_many).map { |a| a.name.to_s }
    selects = table_select_columns(@table)
    selects.each do |column|
      if bt_columns.include?(column[:name])
        if params[column[:name]].present?
          res = res.joins(column[:name].to_sym)
            .where(column[:name].pluralize => { id: params[column[:name]] })
        else
          res = res.includes(column[:name].to_sym)
        end
      elsif habtm_columns.include?(column[:name])
        if params[column[:name]].present?
          res = res.joins(column[:name].to_sym)
            .where(column[:name].pluralize => { id: params[column[:name]] })
        else
          res = res.includes(column[:name].to_sym)
        end
        @column_names << "#{column[:name]}_habtm"
      elsif hm_columns.include?(column[:name])
        if params[column[:name]].present?
          res = res.joins(column[:name].to_sym)
            .where(column[:name].pluralize => { id: params[column[:name]] })
        else
          res = res.includes(column[:name].to_sym)
        end
        @column_names << "#{column[:name]}_hm"
      elsif column[:type] == :join
        if params[column[:name]].present?
          res = res.joins(column[:join_table])
            .where(column[:join_table] =>
            { column[:name] => params[column[:name]] })
        else
          res = res.includes(column[:join_table])
        end
        @column_names << "#{column[:name]}|#{column[:join_table]}_join"
      elsif params[column[:name]].present?
        res = res.where("#{column[:name]} = ?", "#{params[column[:name]]}")
        @column_names << column[:name]
      end
    end

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

  def table_input_columns(table)
    # Create form inputs for:
    column_list = []

    if table == Unit
      column_list << { name: "unit_no", type: "string" }
    elsif table == Feature
      column_list << { name: "feature_no", type: "string" }
    elsif table == Stratum
      column_list << { name: "strat_all", type: "string" }
      column_list << { name: "strat_alpha", type: "string" }
      column_list << { name: "strat_one", type: "string" }
      column_list << { name: "strat_two", type: "string" }
      column_list << { name: "strat_three", type: "string" }
    end

    # Columns whose names
    # don't begin with "strat"
    # don't match "id", "room", or "unit"
    # don't end in "_at", "_id", "_no", "code", or "type"
    table.columns.each do |c|
      if !c.name[/^strat/] \
      && !c.name[/^(?:id|room|unit)$/] \
      && !c.name[/(?:_at|_id|_no|code|type)$/]
        column_list << { name: c.name.to_s, type: c.type }
      end
    end

    column_list
  end

  def table_select_columns(table)
    # Create select dropdowns for:
    column_list = []

    # Columns whose names
    # end in "_no" not preceded by "feature", "code", or "type"
    table.columns.each do |c|
      if c.name[/(?:(?<!feature|#{table.to_s.downcase})_no|code|type)$/]
        column_list << { name: c.name.to_s, type: :column }
      end
    end

    # All associations except to Common Search Options:
    #   unit, stratum, feature, or occupation
    table.reflect_on_all_associations(:belongs_to)
      .reject{ |a| a.name[/(?:^unit|^stratum|^feature|occupation)$/] }
      .each { |a| column_list << { name: a.name.to_s, type: :assoc } }

    table.reflect_on_all_associations(:has_many)
      .reject{ |a| a.name[/(?:^units|^strata|^features|occupations)$/] }
      .each { |a| column_list << { name: a.name.to_s, type: :assoc } }

    table.reflect_on_all_associations(:has_and_belongs_to_many)
      .reject{ |a| a.name[/(?:^units|^strata|^features|occupations)$/] }
      .each { |a| column_list << { name: a.name.to_s, type: :assoc } }

    if SETTINGS["hide_sensitive_image_records"]
      column_list.reject!{ |column| %w[image_human_remain]
        .include?(column[:name]) }
    end

    if table == Stratum
      column_list << { name: "feature_no", type: :join, join_table: :features }
    end

    column_list
  end
end
