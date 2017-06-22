module ApplicationHelper

  def doc_type_active(type)
    type_name = type.name.parameterize('_')
    return type_name == @type ? "doc_type_active" : ""
  end

  def new_document_link(type)
    # contains controller and action so
    # do not need a named route
    options = params.to_unsafe_h
    type_name = type.name.parameterize("_")
    # replace the old document type selection
    options["type"] = type_name
    return options
  end

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
