class SelectArtifact < ApplicationRecord
  belongs_to :occupation
  has_and_belongs_to_many :features
  has_many :strata, -> {distinct}, :through => :features
  has_many :units, -> {distinct}, :through => :strata

  def self.abstraction
    {
      assoc_col: "sa_no",
      description: "",
      disabled: %w[],
      labels: {
        sa_no: "Select Artifact Number",
        fs_no: "FS Number",
        sa_form: "Select Artifact Form"
      },
      primary: %w[],
      selects: %w[]
    }
  end

  def self.sorted
    order("sa_no")
  end

  def to_label
    artifact_no
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
