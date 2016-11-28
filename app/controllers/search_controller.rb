class SearchController < ApplicationController

  def unit
    @unit = Unit.where(:unit_no => params["id"]).first
  end

  def zone
    @units = Unit.joins(:zone).where(:zone => params["id"])
  end

end
