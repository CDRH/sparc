class ImageController < ApplicationController

  def index
    @images = Image.includes(:image_subjects, :units)
      .paginate(:page => params[:page], :per_page => 20)
  end

  def show
    @image = Image.includes(:image_subjects, :units)
      .find_by(image_no: params[:number])
  end

end
