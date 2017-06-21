class DocumentType < ActiveRecord::Base

  has_many :documents
  has_many :units, -> {distinct}, :through => :documents

  def self.sorted
    order("rank")
  end

  def to_label
    name
  end

end
