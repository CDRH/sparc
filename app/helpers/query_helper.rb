module QueryHelper
  def checked?(value, paramlist)
    if paramlist.blank?
      return false
    else
      return paramlist.include?(value.to_s)
    end
  end

  def params_hash
    # create a new object so that the params
    # are not directly altered
    options = params.to_unsafe_h
  end

  def delimit(number)
    number_with_delimiter(number)
  end

  def display_value(record, column)
    # default to current value
    value = record[column]
    if column[/_id$/]
      # get name without _id
      assoc_col = column[/^(.+)_id$/, 1]
      if record.respond_to?(assoc_col)
        if record.send(assoc_col).present?
          if record.send(assoc_col).respond_to?(:name)
            value = record.send(assoc_col).name
          else
            value = record.send(assoc_col).id
          end
        else
          value = "N/A"
        end
      else
        if record.send(assoc_col.pluralize).present?
          assoc_values = record.send(assoc_col.pluralize)
            .map { |r| r.send(assoc_col << "_no") }.join("; ")
          value = assoc_values
        else
          value = "N/A"
        end
      end
    # let through columns that aren't "id" or "created_at", etc
    elsif !column[/(?:^id|_at)$/]
      value = value
    else
      value = nil
    end
    return value
  end

  def select_from_assoc(column, param_name)
    select_tag param_name,
               options_from_collection_for_select(column[:name]
                                                    .classify.constantize
                                                    .distinct.order(:name),
                                                  "id", "name",
                                                  params[param_name]),
               class: "form-control", include_blank: true
  end

  def select_from_column(model_class, column, param_name)
    select_tag param_name,
               options_for_select(model_class.pluck(column[:name]).compact
                                    .uniq.sort,
                                  params[param_name]),
               class: "form-control", include_blank: true
  end

  def select_from_join(model_class, column, param_name)
    select_tag param_name,
               options_for_select(model_class.joins(column[:join_table])
                                           .pluck(column[:name])
                                           .uniq.sort,
                                  params[param_name]),
               class: "form-control", include_blank: true
  end

  def sensitive_record?(column)
    sensitive = false

    if SETTINGS["hide_sensitive_image_records"] &&
      column == "image_human_remain_id"
      sensitive = true
    end

    sensitive
  end
end
