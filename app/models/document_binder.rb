class DocumentBinder < ActiveRecord::Base
  # corresponds to https://github.com/matrix-msu/ARCSCore/blob/master/ARCS_4_ResourceSchema.csv

  has_many :documents
  has_many :units, -> {distinct}, :through => :documents

  def self.sorted
    order("resource_id")
  end

  def pages
    documents.length
  end

  def to_label
    title
  end

end
