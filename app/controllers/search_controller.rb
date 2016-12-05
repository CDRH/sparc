class SearchController < ApplicationController

  def index
    units = Unit.includes(
      :inferred_function,
      :type_description,
      :unit_occupation,
    )

    # images = images.where("image_no LIKE ?", "%#{params['image_no']}%") if !params["image_no"].blank?
    units = units.joins(:zone).where(:zones => { :id => params["zone"] }) if !params["zone"].blank?
    @result_num = units.size

    @units = units.paginate(:page => params[:page], :per_page => 20)
  end

  def unit
    @unit = Unit.where(:unit_no => params["number"]).first
  end

  def zone
    @units = Unit.joins(:zone).where("zones.number" => params["number"])
  end

end
