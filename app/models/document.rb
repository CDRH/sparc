class Document < ActiveRecord::Base
  # corresponds to https://github.com/matrix-msu/ARCSCore/blob/master/ARCS_5_PagesSchema.csv

  belongs_to :document_binder
  belongs_to :document_type
  has_and_belongs_to_many :units

  def self.sorted
    order("page_id")
  end

  def canonical_unit_no
    image_upload[/^([^_]*)(?=_)/]
  end

  def path
    "#{canonical_unit_no}/#{canonical_unit_no}_#{document_type.code}_#{scan_no}.jpeg"
  end

  def to_label
    page_id
  end

  def authorized_for_update?
    puts "---------#{current_user}"
    current_user != nil ? true : false
  end
  def authorized_for_delete?
    current_user != nil ? true : false
  end
  def authorized_for_create?
    puts "---------#{current_user}"
    current_user != nil ? true : false
  end
end
