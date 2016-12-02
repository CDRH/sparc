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
    images = add_to_query(images, :image_assocnoegs, params["assocnoeg"], :image_assocnoeg, true)
    images = add_to_query(images, :image_boxes, params["box"], :image_box, true)
    images = add_to_query(images, :image_creators, params["creator"], :image_creator, true)
    images = add_to_query(images, :image_formats, params["format"], :image_format, false)
    images = add_to_query(images, :image_human_remains, params["remain"], :image_human_remain, false)
    images = add_to_query(images, :image_orientations, params["orientation"], :image_orientation, true)
    images = add_to_query(images, :image_qualities, params["quality"], :image_quality, true)
    images = add_to_query(images, :image_subjects, params["subject"], :image_subjects, false)
    images = add_to_query(images, :unit_occupations, params["occupation"], :unit_occupations, true)
    images = add_to_query(images, :units, params["unit"], :units, false)
    images = add_to_query(images, :zones, params["zone"], :zones, false)

    @images = images.paginate(:page => params[:page], :per_page => 20)
    @occupations = UnitOccupation.distinct.joins(:images).order("occupation")
    @units = Unit.distinct.joins(:images).order("unit_no")
    @zones = Zone.distinct.joins(:images).order("number")
  end

  def show
    @image = Image.includes(:image_subjects, :units)
      .find_by(image_no: params[:number])
  end

  private

  # essentially creating: images.where(:where_rel => { :id => param }).includes(:relationship)
  # but avoiding code duplication, also only will join or include if needed for query
  def add_to_query query_obj, where_rel, param, relationship, joins=true
    if !param.blank?
      query_obj = query_obj.where(where_rel => { :id => param })
      if joins
        query_obj = query_obj.joins(relationship)
      else
        query_obj = query_obj.includes(relationship)
      end
    end
    return query_obj
  end

end
