class SearchController < ApplicationController

  def unit
    @unit = Unit.where(:unit_no => params["id"]).first
  end

  def zone
    # pad the incoming id to look like 001
    zone_like = params["id"].rjust(3, "0")
    @units = Unit.where("unit_no LIKE ?", "#{zone_like}%")
  end

end
