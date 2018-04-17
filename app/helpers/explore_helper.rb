module ExploreHelper

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
