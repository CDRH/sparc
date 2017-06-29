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
