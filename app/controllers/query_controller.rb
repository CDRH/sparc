require_relative "../renderers/csv.rb"

class QueryController < ApplicationController
  include ActiveRecordAbstraction

  def category
    params.require(:category)

    if params[:category][/^(?:features|strata|images)$/]
      # These are lone tables, so call the form action and render its view
      params[:type] = params[:category]
      form
      render :form
    end
  end

  def form
    params.require([:category, :type])

    # Clear common search options
    if params["search_clear"].present?
      session[:common_search_unit] = nil
      session[:common_search_unit_class] = nil
      session[:common_search_occupation] = nil
      session[:common_search_strat_grouping] = nil
      session[:common_search_feature_group] = nil
    end

    @tables = category_type_tables.map { |t| {name: t,
                                              label: t.pluralize.titleize,
                                              count: t.classify.constantize
                                                       .count} }

    params[:table] =
      params[:table].present? ? params[:table] : @tables.first[:name]

    @table_class = params[:table].to_s.classify.constantize
    @table_inputs = table_input_columns(@table_class)
    @table_selects = table_select_columns(@table_class)
  end

  def results
    params.require([:category, :type, :table])

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

    selects = table_select_columns(@table)
    selects.each do |column|
      if params[column[:name]].present?
        if @table.reflect_on_all_associations(:belongs_to)
             .map{ |a| a.name.to_s }.include?(column[:name])
          res = res.joins(column[:name].to_sym)
                   .where(column[:name].pluralize =>
                          { id: params[column[:name]] })
        elsif column[:type] == :join
          res = res.joins(column[:join_table])
                   .where(column[:join_table] =>
                          { column[:name] => params[column[:name]] })
        else
          res = res.where("#{column[:name]} = ?",
                            "%#{params[column[:name]]}%")
        end
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

  def category_type_tables
    case params[:category]
    when "samples"
      case params[:type]
      when "pollens"
        return ["pollen_inventory"]
      when "soils"
        return ["soil"]
      when "tree_rings"
        return ["tree_ring"]
      end
    when "artifacts"
      case params[:type]
      when "ceramics"
        return ["ceramic_inventory", "ceramic_clap", "ceramic",
                "ceramic_vessel"]
      when "eggshells"
        return ["eggshell"]
      when "faunal"
        return ["bone_tool", "faunal_artifacts", "faunal_inventory"]
      when "lithics"
        return ["lithic_inventory", "lithic_debitage", "lithic_tool"]
      when "ornaments"
        return ["ornament"]
      when "perishables"
        return ["perishable"]
      when "woods"
        return ["wood_inventory"]
      end
    when "features"
      return ["features"]
    when "strata"
      return ["strata"]
    when "images"
      return ["images"]
    end
  end

  def common_search(res)
    # Save params in session
    session[:common_search_unit] = params["unit"]
    session[:common_search_unit_class] = params["unit_class"]
    session[:common_search_occupation] = params["occupation"]
    session[:common_search_strat_grouping] = params["strat_grouping"]
    session[:common_search_feature_group] = params["feature_group"]

    # Units
    if (params["unit"].present? || params["unit_class"].present?) \
    && res.reflect_on_all_associations.map { |a| a.name }.include?(:units)
      res = res.joins(:units)

      if params["unit"].present?
        res = res.where(units: { id: params["unit"] })
      end

      if params["unit_class"].present?
        res = res.where(units: { unit_class_id: params["unit_class"] })
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

    return res
  end

  def table_input_columns(table)
    # Create form inputs for:
    column_list = []

    if table == Feature
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

    return column_list
  end

  def table_select_columns(table)
    # Create select dropdowns for:
    column_list = []

    # Columns whose names
    # end in "_no" not preceded by "feature", "code", or "type"
    table.columns.each do |c|
      if c.name[/(?:(?<!feature)_no|code|type)$/]
        column_list << { name: c.name.to_s, type: :column }
      end
    end

    # All belongs_to associations except to unit, stratum, feature,
    # inventory, or occupation
    table.reflect_on_all_associations(:belongs_to)
      .reject{ |a| a.name[/(?:^unit|^stratum|^feature|_inventory|occupation)$/] }
      .map{ |a| column_list << { name: a.name.to_s, type: :assoc } }

    if SETTINGS["hide_sensitive_image_records"]
      column_list.reject!{ |column| %w[image_human_remain image_subjects]
        .include?(column[:name]) }
    end

    if table == Stratum
      column_list << { name: "feature_no", type: :join, join_table: :features }
    end

    return column_list
  end
end
