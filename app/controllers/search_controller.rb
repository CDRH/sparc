class SearchController < ApplicationController

  def unit
    @unit = Unit.where(:unit_no => params["number"]).first
    @images = Image.joins(:units).where(:units => { :unit_no => params["number"] }).limit(8)
  end

  def zone
    @units = Unit.joins(:zone).where("zones.number" => params["number"])
  end

end
