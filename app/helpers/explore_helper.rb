module ExploreHelper

  def item_radio_list
    %w[
      bone_tools
      ceramics
      ceramic_claps
      ceramic_inventories
      ceramic_vessels
      eggshells
      faunal_artifacts
      faunal_inventories
      lithic_debitages
      lithic_inventories
      lithic_tools
      obsidian_inventories
      ornaments
      perishables
      pollen_inventories
      soils
      tree_rings
      wood_inventories
    ]
  end

  def related_units(unit)
    rel = []
    units = unit.zone.units
    if units.count > 1
      nos = units.pluck(:unit_no)
      nos.delete(unit.unit_no)
      rel = nos.map { |u| link_to u, unit_path(u) }
    end
    rel
  end

end
