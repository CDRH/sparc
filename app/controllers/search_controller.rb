class SearchController < ApplicationController

  def unit
    @unit = Unit.where(:unit_no => params["number"]).first
  end

  def zone
    @units = Unit.joins(:zone).where("zones.number" => params["number"])
  end

end
