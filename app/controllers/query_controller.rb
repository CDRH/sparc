class QueryController < ApplicationController

  def bones
    @subsection = "artifacts"
    #### SEARCH UI ####
    # tools
    @total_bt = BoneTool.count

    @bt_type = BoneTool.pluck(:tool_type).uniq.sort
    @bt_tpcd = BoneTool.pluck(:tool_type_code).uniq.sort
    @bt_spcd = BoneTool.pluck(:species_code).uniq.sort

    # inventory
    @total_bi = BoneInventory.count

    @bi_enby = BoneInventory.pluck(:entered_by).uniq.sort
    @bi_loca = BoneInventory.pluck(:location).uniq.sort
    @bi_quad = BoneInventory.pluck(:quad).uniq.sort
    @bi_sano = BoneInventory.pluck(:sa_no).uniq.sort
  end

  def bones_results
    if params[:commit] == "Search Bone Tools"
      @res_label = "Bone Tools"
      @column_names = BoneTool.columns.map(&:name)

      res = BoneTool

      # text searches
      res = res.where("fs_no LIKE ?", "%#{params['bt_fsno']}%") if params["bt_fsno"].present?
      res = res.where("depth LIKE ?", "%#{params['bt_dep']}%") if params["bt_dep"].present?
      res = res.where("comments LIKE ?", "%#{params['bt_cmmt']}%") if params["bt_cmmt"].present?
      res = res.where("grid LIKE ?", "%#{params['bt_grid']}%") if params["bt_grid"].present?

      # match searches
      res = res.where("tool_type IN (?)", params["bt_type"]) if params["bt_type"].present?
      res = res.where("tool_type_code = ?", params["bt_tpcd"]) if params["bt_tpcd"].present?
      res = res.where("species_code = ?", params["bt_spcd"]) if params["bt_spcd"].present?
    else  # Search Bone Inventories
      @res_label = "Bone Inventories"
      @column_names = BoneInventory.columns.map(&:name)

      res = BoneInventory.all
    end

    # join searches
    res = global_search res

    @res = res.sorted.paginate(:page => params[:page], :per_page => 20)

    render "results_table"
  end

  def ceramics
    @subsection = "artifacts"

    #### SEARCH UI ####
    # inventory
    @total_ci = CeramicInventory.count
    @ci_enby = CeramicInventory.pluck(:entered_by).uniq.sort
    @ci_loca = CeramicInventory.pluck(:location).uniq.sort
    @ci_quad = CeramicInventory.pluck(:quad).uniq.sort
    @ci_sano = CeramicInventory.pluck(:sa_no).uniq.sort
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

  def global_search res
    res = res.joins(:units)
    res = res.where(units: { id: params["unitno"] }) if params["unitno"].present?
    res = res.where(units: { unit_class_id: params["unitclass"] }) if params["unitclass"].present?
    return res
  end

end
