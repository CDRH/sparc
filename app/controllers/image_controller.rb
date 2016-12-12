class ImageController < ApplicationController

  def index
    # always include these fields because they are used to describe each image
    images = Image.includes(
      :image_format,
      :image_human_remain,
      :image_subjects,
      :unit_occupations,
      :units,
    )
    images = images.where("image_no LIKE ?", "%#{params['image_no']}%") if !params["image_no"].blank?
    images = images.where("comments LIKE ?", "%#{params['comments']}%") if !params["comments"].blank?
    images = add_to_query(images, :image_assocnoegs, params["associated_negative"], :image_assocnoeg, true)
    images = add_to_query(images, :image_boxes, params["box"], :image_box, true)
    images = add_to_query(images, :image_creators, params["creator"], :image_creator, true)
    images = add_to_query(images, :image_formats, params["format"], :image_format, false)
    images = add_to_query(images, :image_human_remains, params["human_remain"], :image_human_remain, false)
    images = add_to_query(images, :image_orientations, params["orientation"], :image_orientation, true)
    images = add_to_query(images, :image_qualities, params["quality"], :image_quality, true)
    images = add_to_query(images, :image_subjects, params["subject"], :image_subjects, false)
    images = add_to_query(images, :unit_occupations, params["occupation"], :unit_occupations, true)
    images = add_to_query(images, :units, params["unit"], :units, false)
    images = add_to_query(images, :zones, params["zone"], :zones, true)

    @result_num = images.size

    @images = images.paginate(:page => params[:page], :per_page => 20)
    @occupations = UnitOccupation.sorted.distinct.joins(:images).order("occupation")
    @units = Unit.sorted.distinct.joins(:images).order("unit_no")
    @zones = Zone.sorted.distinct.joins(:images).order("number")
  end

  def show
    @image = Image.includes(:image_subjects, :units)
      .find_by(image_no: params[:number])
      .sorted
  end

  private

  # essentially creating: images.where(:where_rel => { :id => param }).joins(:relationship)
  # assumes that the tables need to be joined, but can optionally omit join if this table
  # has previously been loaded via includes
  def add_to_query query_obj, where_rel, param, relationship, joins=true
    if !param.blank?
      query_obj = query_obj.where(where_rel => { :id => param })
      query_obj = query_obj.joins(relationship) if joins
    end
    return query_obj
  end

end
