class QueryController < ApplicationController

  def bones
    @subsection = "artifacts"

    #### SEARCH UI ####
    # Inventory
    @total_bi = BoneInventory.count

    @bi_enby = BoneInventory.pluck(:entered_by).uniq.sort
    @bi_loca = BoneInventory.pluck(:location).uniq.sort
    @bi_quad = BoneInventory.pluck(:quad).uniq.sort
    @bi_sano = BoneInventory.pluck(:sa_no).uniq.sort

    # Tools
    @total_bt = BoneTool.count

    @bt_type = BoneTool.pluck(:tool_type).uniq.sort
    @bt_tpcd = BoneTool.pluck(:tool_type_code).uniq.sort
    @bt_spcd = BoneTool.pluck(:species_code).uniq.sort
  end

  def bones_results
    if params[:commit] == "Search Bone Inventory"
      @res_label = "Bone Inventory"
      @column_names = BoneInventory.columns.map(&:name)

      res = BoneInventory.all
    else
      @res_label = "Bone Tools"
      @column_names = BoneTool.columns.map(&:name)

      res = BoneTool

      # text searches
      if params["bt_fsno"].present?
        res = res.where("fs_no LIKE ?", "%#{params['bt_fsno']}%")
      end

      if params["bt_dep"].present?
        res = res.where("depth LIKE ?", "%#{params['bt_dep']}%")
      end

      if params["bt_cmmt"].present?
        res = res.where("comments LIKE ?", "%#{params['bt_cmmt']}%")
      end

      if params["bt_grid"].present?
        res = res.where("grid LIKE ?", "%#{params['bt_grid']}%")
      end

      # match searches
      if params["bt_type"].present?
        res = res.where("tool_type IN (?)", params["bt_type"])
      end

      if params["bt_tpcd"].present?
        res = res.where("tool_type_code = ?", params["bt_tpcd"])
      end

      if params["bt_spcd"].present?
        res = res.where("species_code = ?", params["bt_spcd"])
      end
    end

    # Common search options
    res = global_search res

    @res = res.sorted.paginate(:page => params[:page], :per_page => 20)

    render "results_table"
  end

  def ceramics
    @subsection = "artifacts"

    #### SEARCH UI ####
    # Inventory
    @total_ci = CeramicInventory.count

    @ci_class = CeramicInventory
    @ci_inputs = table_input_columns(CeramicInventory)
    @ci_selects = table_select_columns(CeramicInventory)

    # CLAPs
    @total_cc = CeramicClap.count

    @cc_class = CeramicClap
    @cc_inputs = table_input_columns(CeramicClap)
    @cc_selects = table_select_columns(CeramicClap)

    # 2005 Data
    @total_cd = Ceramic.count

    @cd_class = Ceramic
    @cd_inputs = table_input_columns(Ceramic)
    @cd_selects = table_select_columns(Ceramic)

    # Vessels
    @total_cv = CeramicVessel.count

    @cv_class = CeramicVessel
    @cv_inputs = table_input_columns(CeramicVessel)
    @cv_selects = table_select_columns(CeramicVessel)
  end

  def ceramics_results
    if params[:commit] == "Search Ceramic Inventory"
      @column_names = CeramicInventory.columns.map(&:name)
      @res = CeramicInventory
      @res_label = "Ceramic Inventory"

      inputs = table_input_columns(CeramicInventory)
      inputs.each do |column|
        param_name = "inv_#{column[:name]}"

        if params[param_name].present?
          if column[:type] == "string"
            @res = @res.where("#{column[:name]} LIKE ?",
                              "%#{params[param_name]}%")
          else
            @res = @res.where("#{column[:name]} = ?", params[param_name])
          end
        end
      end

      selects = table_select_columns(CeramicInventory)
      selects.each do |column|
        param_name = "inv_#{column[:name]}"

        if params[param_name].present?
          if CeramicInventory.reflect_on_all_associations(:belongs_to)
               .map{ |a| a.name.to_s }.include?(column[:name])
            @res = @res.joins(column[:name].to_sym)
                     .where(column[:name].pluralize
                            => { id: params[param_name] })
          else
            @res = @res.where("#{column[:name]} = ?",
                              "%#{params[param_name]}%")
          end
        end
      end
    elsif params[:commit] == "Search Ceramic CLAPs"
      @res = CeramicClap
      @res_label = "Ceramic CLAPs"
      @column_names = CeramicClap.columns.map(&:name)

      inputs = table_input_columns(CeramicClap)
      inputs.each do |column|
        param_name = "clap_#{column[:name]}"

        if params[param_name].present?
          if column[:type] == "string"
            @res = @res.where("#{column[:name]} LIKE ?",
                              "%#{params[param_name]}%")
          else
            @res = @res.where("#{column[:name]} = ?", params[param_name])
          end
        end
      end

      selects = table_select_columns(CeramicClap)
      selects.each do |column|
        param_name = "clap_#{column[:name]}"

        if params[param_name].present?
          if CeramicClap.reflect_on_all_associations(:belongs_to)
               .map{ |a| a.name.to_s }.include?(column[:name])
            @res = @res.joins(column[:name].to_sym)
                     .where(column[:name].pluralize
                            => { id: params[param_name] })
          else
            @res = @res.where("#{column[:name]} = ?",
                              "%#{params[param_name]}%")
          end
        end
      end
    elsif params[:commit] == "Search Ceramics 2005 Data"
      @res = Ceramic
      @res_label = "Ceramics 2005 Data"
      @column_names = Ceramic.columns.map(&:name)

      inputs = table_input_columns(Ceramic)
      inputs.each do |column|
        param_name = "data_#{column[:name]}"

        if params[param_name].present?
          if column[:type] == "string"
            @res = @res.where("#{column[:name]} LIKE ?",
                              "%#{params[param_name]}%")
          else
            @res = @res.where("#{column[:name]} = ?", params[param_name])
          end
        end
      end

      selects = table_select_columns(Ceramic)
      selects.each do |column|
        param_name = "data_#{column[:name]}"

        if params[param_name].present?
          if Ceramic.reflect_on_all_associations(:belongs_to)
               .map{ |a| a.name.to_s }.include?(column[:name])
            @res = @res.joins(column[:name].to_sym)
                .where(column[:name].pluralize
                       => { id: params[param_name] })
          else
            @res = @res.where("#{column[:name]} = ?",
                              "%#{params[param_name]}%")
          end
        end
      end
    elsif params[:commit] == "Search Ceramic Vessels"
      @res = CeramicVessel
      @res_label = "Ceramic Vessels"
      @column_names = CeramicVessel.columns.map(&:name)

      inputs = table_input_columns(CeramicVessel)
      inputs.each do |column|
        param_name = "vessel_#{column[:name]}"

        if params[param_name].present?
          if column[:type] == "string"
            @res = @res.where("#{column[:name]} LIKE ?",
                              "%#{params[param_name]}%")
          else
            @res = @res.where("#{column[:name]} = ?", params[param_name])
          end
        end
      end

      selects = table_select_columns(CeramicVessel)
      selects.each do |column|
        param_name = "data_#{column[:name]}"

        if params[param_name].present?
          if CeramicVessel.reflect_on_all_associations(:belongs_to)
               .map{ |a| a.name.to_s }.include?(column[:name])
            @res = @res.joins(column[:name].to_sym)
                     .where(column[:name].pluralize
                            => { id: params[param_name] })
          else
            @res = @res.where("#{column[:name]} = ?",
                              "%#{params[param_name]}%")
          end
        end
      end
    end

    # Common search options
    @res = global_search @res

    @res = @res.sorted.paginate(:page => params[:page], :per_page => 20)

    render "results_table"
  end

  def eggshells
    @subsection = "artifacts"

    #### SEARCH UI ####
    # eggshells
    @total_eg = Eggshell.count
    @eg_item = EggshellItem.all
    @eg_msdt = Eggshell.pluck(:museum_date).uniq.sort
    @eg_quad = Eggshell.pluck(:quad).uniq.sort
    @eg_sbin = Eggshell.pluck(:storage_bin).uniq.sort
  end

  def lithics
    @subsection = "artifacts"

    #### SEARCH UI ####
    # inventory
    @total_li = LithicInventory.count
    @li_artp = LithicInventory.pluck(:art_type).uniq.sort
    @li_ct = LithicInventory.pluck(:count).uniq.sort
    @li_enby = LithicInventory.pluck(:entered_by).uniq.sort
    @li_loca = LithicInventory.pluck(:location).uniq.sort
  end

  def ornaments
    @subsection = "artifacts"

    #### SEARCH UI ####
    # ornaments
    @total_om = Ornament.count
    @om_anly = Ornament.pluck(:analyst).uniq.sort
    @om_ct = Ornament.pluck(:count).uniq.sort
    @om_item = Ornament.pluck(:item).uniq.sort
    @om_occu = Occupation.all.order("name")
    @om_phot = Ornament.pluck(:photographer).uniq.sort
    @om_quad = Ornament.pluck(:quad).uniq.sort
  end

  def perishables
    @subsection = "artifacts"

    #### SEARCH UI ####
    # perishables
    @total_ps = Perishable.count
    @ps_arst = Perishable.pluck(:artifact_structure).uniq.sort
    @ps_ct = Perishable.pluck(:count).uniq.sort
    @ps_exlc = Perishable.pluck(:exhibit_location).uniq.sort
    @ps_quad = Perishable.pluck(:quad).uniq.sort
    @ps_stlc = Perishable.pluck(:storage_location).uniq.sort
    @ps_type = Perishable.pluck(:artifact_type).uniq.sort
  end

  def soils
    @subsection = "artifacts"

    #### SEARCH UI ####
    # soils (inventory?)
    @total_sl = Soil.count
    @sl_artp = ArtType.all
    @sl_enby = Soil.pluck(:entered_by).uniq.sort
    @sl_loca = Soil.pluck(:location).uniq.sort
    @sl_quad = Soil.pluck(:quad).uniq.sort

  end

  def woods
    @subsection = "artifacts"
  end

  private

  def global_search(res)
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
    if params["occupation"].present? \
    && res.reflect_on_all_associations.map { |a| a.name }
         .include?(:occupations)
      res = res.joins(:occupation)
              .where(occupations: { id: params["occupation"] })
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

    # Columns whose names
    # don't begin with "strat"
    # don't match "id", "room", or "unit"
    # don't end in "_at", "_id", "_no", "code", or "type"
    table.columns.each do |c|
      if !c.name[/^strat/] \
      && !c.name[/^(?:id|room|unit)$/] \
      && !c.name[/(?:_at|_id|_no|code|type)$/]
        column_list << {name: c.name.to_s, type: c.type}
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
        column_list << {name: c.name.to_s, type: :column}
      end
    end

    # All belongs_to associations except to unit, strata, feature, inventory
    table.reflect_on_all_associations(:belongs_to)
      .reject{ |a| a.name[/(?:^unit|^strata|^features?|_inventory)$/] }
      .map{ |a| column_list << { name: a.name.to_s, type: :assoc} }

    return column_list
  end
end
