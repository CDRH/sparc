class ImageController < ApplicationController

  def index
    images = Image.includes(:image_subjects, :units)
    images = images.where("image_no LIKE ?", "%#{params['image_no']}%") if !params["image_no"].blank?
    images = images.where("comments LIKE ?", "%#{params['comments']}%") if !params["comments"].blank?
    @images = images.includes(:image_subjects, :units)
      .paginate(:page => params[:page], :per_page => 20)
  end

  def show
    @image = Image.includes(:image_subjects, :units)
      .find_by(image_no: params[:number])
  end

end
