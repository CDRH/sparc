class DocumentType < ActiveRecord::Base

  has_many :documents

  def self.sorted
    order("rank")
  end

  def to_label
    name
  end

end
