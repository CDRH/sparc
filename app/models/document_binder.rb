class DocumentBinder < ActiveRecord::Base
  # corresponds to https://github.com/matrix-msu/ARCSCore/blob/master/ARCS_4_ResourceSchema.csv

  has_many :documents
  has_many :units, -> {distinct}, :through => :documents

  def self.abstraction
    {
      assoc_input_type: "select",
      assoc_input_column: "title"
    }
  end

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
