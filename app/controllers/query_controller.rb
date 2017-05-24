class QueryController < ApplicationController

  def bones
    @subsection = "artifacts"
    #### FILTERS ####
    # tools
    @total_bt = BoneTool.count
    @bt_type = BoneTool.pluck(:tool_type).uniq.sort
    @bt_tpcd = BoneTool.pluck(:tool_type_code).uniq.sort
    @bt_spcd = BoneTool.pluck(:species_code).uniq.sort
    # inventory
    @total_bi = BoneInventory.count
    @bi_enby = BoneInventory.pluck(:entby).uniq.sort
    @bi_loca = BoneInventory.pluck(:location).uniq.sort
    @bi_quad = BoneInventory.pluck(:quad).uniq.sort
    @bi_sano = BoneInventory.pluck(:sano).uniq.sort
  end

  def ceramics
    @subsection = "artifacts"

    #### FILTERS ####
    # inventory
    @total_ci = CeramicInventory.count
    @ci_enby = CeramicInventory.pluck(:entby).uniq.sort
    @ci_loca = CeramicInventory.pluck(:location).uniq.sort
    @ci_quad = CeramicInventory.pluck(:quad).uniq.sort
    @ci_sano = CeramicInventory.pluck(:sano).uniq.sort
  end

  def eggshells
    @subsection = "artifacts"

    #### FILTERS ####
    # eggshells
    @total_eg = Eggshell.count
    @eg_affl = EggshellAffiliation.pluck(:affiliation).uniq.sort
    @eg_item = EggshellItem.pluck(:item).uniq.sort
    @eg_msdt = Eggshell.pluck(:museum_date).uniq.sort
    @eg_quad = Eggshell.pluck(:quad).uniq.sort
    @eg_sbin = Eggshell.pluck(:storage_bin).uniq.sort
  end

  def lithics
    @subsection = "artifacts"

    #### FILTERS ####
    # inventory
    @total_li = LithicInventory.count
    @li_artp = LithicInventory.pluck(:art_type).uniq.sort
    @li_ct = LithicInventory.pluck(:lithic_inventory_count).uniq.sort
    @li_enby = LithicInventory.pluck(:entby).uniq.sort
    @li_loca = LithicInventory.pluck(:location).uniq.sort
  end

  def faunal
    @subsection = "artifacts"
  end

  def perishables
    @subsection = "artifacts"
  end

  def ornaments
    @subsection = "artifacts"
  end

  def wood
    @subsection = "artifacts"
  end

end
