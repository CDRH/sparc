module QueryHelper
  def checked?(value, paramlist)
    if paramlist.blank?
      return false
    else
      return paramlist.include?(value.to_s)
    end
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
end
