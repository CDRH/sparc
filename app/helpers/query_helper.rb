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

  def display_value(result, column)
    res = ""
    if column[/_id$/]
      assoc_col = column[/^(.+)_id$/, 1]
      if assoc_col == "occupation"
        res = Occupation.where(id: result[:occupation_id]).first.name
      elsif result.respond_to?(assoc_col)
        if result.send(assoc_col).present?
          if result.send(assoc_col).respond_to?(:name)
            res = result.send(assoc_col).name
          else
            res = result.send(assoc_col).id
          end
        else
          res = "N/A"
        end
      elsif result.respond_to?(assoc_col.pluralize)
        if result.send(assoc_col.pluralize).present?
          assoc_obj = result.send(assoc_col.pluralize)
          if assoc_obj.first.respond_to?("name")
            res = assoc_obj.map { |r| r.name }.join("; ")
          elsif assoc_obj.first.respond_to?(assoc_col << "_no")
            res = assoc_obj.map { |r| r.send(assoc_col << "_no") }
              .join("; ")
          elsif assoc_obj.first.respond_to?("id")
            res = assoc_obj.map { |r| r.id }.join("; ")
          end
        else
          res = "N/A"
        end
      else
        res = "N/A"
      end
    elsif !column[/(?:^id|_at)$/]
      res = result[column]
    end
    res
  end

  def params_copy
    # create a new object so that the params
    # are not directly altered
    params.to_unsafe_h
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
