class ImageController < ApplicationController

  def index
    images = Image.includes(:image_subjects, :units)
    images = images.where("image_no LIKE ?", "%#{params['image_no']}%") if !params["image_no"].blank?
    images = images.where("comments LIKE ?", "%#{params['comments']}%") if !params["comments"].blank?
    images = images.where(:image_assocnoegs => {:id => params["assocnoeg"]}) if !params["assocnoeg"].blank?
    images = images.where(:image_boxes => {:id => params["box"]}) if !params["box"].blank?
    images = images.where(:image_creators => {:id => params["creator"]}) if !params["creator"].blank?
    images = images.where(:image_formats => {:id => params["format"]}) if !params["format"].blank?
    images = images.where(:image_human_remains => {:id => params["remain"]}) if !params["remain"].blank?
    images = images.where(:image_orientations => {:id => params["orientation"]}) if !params["orientation"].blank?
    images = images.where(:image_qualities => {:id => params["quality"]}) if !params["quality"].blank?
    images = images.where(:image_subjects => {:id => params["subject"]}) if !params["subject"].blank?
    images = images.where(:units => {:id => params["unit"]}) if !params["unit"].blank?
    images = images.joins(
      :image_assocnoeg,
      :image_box,
      :image_creator,
      :image_orientation,
      :image_quality
    )
    images = images.includes(
      :image_format,
      :image_human_remain,
      :image_subjects,
      :units
    )
    @images = images.paginate(:page => params[:page], :per_page => 20)
  end

  def show
    @image = Image.includes(:image_subjects, :units)
      .find_by(image_no: params[:number])
  end

end
