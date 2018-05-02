class Stratum < ActiveRecord::Base
  belongs_to :occupation
  belongs_to :strat_type
  belongs_to :unit
  has_one :strat_grouping, :through => :strat_type

  has_many :tree_rings
  has_and_belongs_to_many :features

  def self.abstraction
    {
      assoc_col: "strat_all",
      description: <<-DESC,
The Strata analysis table (previously known as the Codex) tracks all strata
identified at Salmon during excavations or subsequently added during analysis
and reporting. It derives from the original Salmon project data. The table was
extensively modified and revised during Archaeology Southwest's Salmon Project
(2001-2018). During the SPARC project (2015-2018), data within this table were
edited and cross-checked against other sources.
      DESC
      disabled: %w[],
      labels: {
      },
      primary: %w[strat_all strat_alpha strat_type comments],
      selects: %w[]
    }
  end

  def self.sorted
    order("strat_all")
  end

  def to_label
    "#{unit.to_label if unit} : #{strat_all} #{strat_alpha}"
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
