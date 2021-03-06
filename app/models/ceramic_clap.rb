class CeramicClap < ActiveRecord::Base
  has_and_belongs_to_many :features
  has_many :strata, -> {distinct}, :through => :features
  has_many :units, -> {distinct}, :through => :strata

  belongs_to :ceramic_clap_type
  belongs_to :ceramic_clap_group_type
  belongs_to :ceramic_clap_tradition
  belongs_to :ceramic_clap_vessel_form
  belongs_to :ceramic_clap_temper

  def self.abstraction
    {
      assoc_col: "record_field_key_no",
      description: <<-DESC,
The Ceramic CLAP table originates from the original San Juan Valley
Archaeological Program, and represents a portion of Hayward Franklin's Salmon
ceramic lab output. CLAP is an acronym that stands for Ceramic Limited Attribute
Program. The proveniences in this file are almost exclusively Chacoan in origin.
During the SPARC project (2015-2018), data within this table were edited and
cross-checked against other sources.
      DESC
      disabled: %w[],
      labels: {
      },
      primary: %w[
        ceramic_clap_type ceramic_clap_group_type ceramic_clap_tradition
        ceramic_clap_vessel_form ceramic_clap_temper
      ],
      selects: %w[
        ceramic_clap_type ceramic_clap_group_type ceramic_clap_tradition
        ceramic_clap_vessel_form ceramic_clap_temper
      ]
    }
  end

  def self.sorted
    order("ceramic_claps.record_field_key_no")
  end

  def to_label
    record_field_key_no
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
