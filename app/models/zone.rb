class Zone < ActiveRecord::Base
  has_many :units
  has_many :documents, -> {distinct}, :through => :units
  has_many :images, -> {distinct}, :through => :units
  
  validates_uniqueness_of :name

  def self.sorted
    order("zones.name")
  end

  def media_maps
    documents.where(document_type: DocumentType.where(code: "MM"))
  end

  def to_label
    name
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
