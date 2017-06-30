module ApplicationHelper
  def active?(value, comparison=:current_page)
    if comparison == :action
      current_page_ary_or_direct(:action, value)
    elsif comparison == :controller
      current_page_ary_or_direct(:controller, value)
    elsif comparison == :current_page
      current_page_ary_or_direct(nil, value)
    else
      if value.class == Array
        value.each do |v|
          return "active" if v == comparison
        end

        return ""
      elsif value.class == Regexp
        value.match(comparison) ? "active" : ""
      else
        value == comparison ? "active" : ""
      end
    end
  end

  def doc_type_active(type)
    type_name = type.name.parameterize(separator: '_')
    return type_name == @type ? "doc_type_active" : ""
  end

  def new_document_link(type)
    # contains controller and action so
    # do not need a named route
    options = params.to_unsafe_h
    type_name = type.name.parameterize(separator: "_")
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

  private

  def current_page_ary_or_direct(opts_key, value)
    if value.class == Array
      value.each do |v|
        begin
          if opts_key.nil?
            return "active" if current_page?(v)
          else
            return "active" if current_page?(opts_key => v)
          end
        rescue
          # Rescue when current_page? throws "No route matches" exception
          return "active" if !opts_key.nil? && params[opts_key] == v
        end
      end

      return ""
    elsif value.class == Regexp
      if !opts_key.nil?
        value.match(params[opts_key]) ? "active" : ""
      end
    else
      begin
        if opts_key.nil?
          current_page?(value) ? "active" : ""
        else
          current_page?(opts_key => value) ? "active" : ""
        end
      rescue
        if !opts_key.nil?
          # Rescue when current_page? throws "No route matches" exception
          params[opts_key] == value ? "active" : ""
        end
      end
    end
  end
end
