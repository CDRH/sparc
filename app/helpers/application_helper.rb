module ApplicationHelper
  def feature_units_form_column(record, column)
    "#{record.units.map{|u| u.to_label}.join(', ')}"
  end
  def bone_tool_units_form_column(record, column)
    "#{record.units.map{|u| u.to_label}.join(', ')}"
  end
  def eggshell_units_form_column(record, column)
    "#{record.units.map{|u| u.to_label}.join(', ')}"
  end
  def eggshell_strata_form_column(record, column)
    "#{record.strata.map{|u| u.to_label}.join(', ')}"
  end
  def eggshell_features_form_column(record, column)
    "#{record.features.map{|u| u.to_label}.join(', ')}"
  end
end
