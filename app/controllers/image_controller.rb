class ImageController < ApplicationController
  before_action :set_section

  def index
    # always include these fields because they are used to describe each image
    images = Image.includes(
      :image_format,
      :image_human_remain,
      :image_subjects,
      :units,
    )
    images = images.where(file_exists: true)
    images = images.where("images.image_no LIKE ?", "%#{params['image_no']}%") if present?(params["image_no"])
    images = images.where("images.comments LIKE ?", "%#{params['comments']}%") if present?(params["comments"])
    images = add_to_query(images, :image_boxes, params["box"], :image_box, true)
    images = add_to_query(images, :image_creators, params["creator"], :image_creator, true)
    images = add_to_query(images, :image_formats, params["format"], :image_format, false)
    images = add_to_query(images, :image_human_remains, params["human_remain"], :image_human_remain, false)
    images = add_to_query(images, :image_orientations, params["orientation"], :image_orientation, true)
    images = add_to_query(images, :image_qualities, params["quality"], :image_quality, true)
    images = add_to_query(images, :image_subjects, params["subject"], :image_subjects, false)
    images = add_to_query(images, :units, params["unit"], :units, false)

    @result_num = images.size

    @images = images.paginate(:page => params[:page], :per_page => 20)
    @units = Unit.sorted.distinct.joins(:images).order("unit_no")
  end

  def show
    @image = Image.includes(:image_subjects, :units)
      .find_by(image_no: params[:number])
  end

  private

  # essentially creating: images.where(:where_rel => { :id => param }).joins(:relationship)
  # assumes that the tables need to be joined, but can optionally omit join if this table
  # has previously been loaded via includes
  def add_to_query(query_obj, where_rel, param, relationship, joins=true)
    if present?(param)
      query_obj = query_obj.where(where_rel => { :id => param })
      query_obj = query_obj.joins(relationship) if joins
    end
    return query_obj
  end

  def set_section
    @section = "images"
  end

end
