class QueryController < ApplicationController

  def bones
    @subsection = "artifacts"
    # filter / search population
    @total_bt = BoneTool.count
    @bt_type = BoneTool.uniq.pluck(:tool_type).sort
    @bt_tpcd = BoneTool.uniq.pluck(:tool_type_code).sort
    @bt_spcd = BoneTool.uniq.pluck(:species_code).sort

    @total_bi = BoneInventory.count
    @bi_enby = BoneInventory.uniq.pluck(:entby).sort
    @bi_loca = BoneInventory.uniq.pluck(:location).sort
    @bi_quad = BoneInventory.uniq.pluck(:quad).sort
    @bi_sano = BoneInventory.uniq.pluck(:sano).sort
  end

  def ceramics
    @subsection = "artifacts"

    # filter / search population
    @total_ci = CeramicInventory.count
    @ci_enby = CeramicInventory.uniq.pluck(:entby).sort
    @ci_loca = CeramicInventory.uniq.pluck(:location).sort
    @ci_quad = CeramicInventory.uniq.pluck(:quad).sort
    @ci_sano = CeramicInventory.uniq.pluck(:sano).sort
  end

  def lithics
    @subsection = "artifacts"
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
