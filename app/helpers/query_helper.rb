module QueryHelper
  include ActiveRecordAbstraction

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

  def params_copy
    # create a new object so that the params
    # are not directly altered
    params.to_unsafe_h
  end

  def select_from_assoc(column, param_name)
    # Check if model defines column to use instead of default "name"
    if column[:name].classify.constantize.respond_to?("abstraction")
      model = column[:name].classify.constantize
      abstraction = model.send("abstraction")
      select_tag param_name,
                 options_from_collection_for_select(
                   model.distinct.order(abstraction[:assoc_input_column]),
                   "id", abstraction[:assoc_input_column], params[param_name]
                 ),
                 class: "form-control", include_blank: true
    else
      select_tag param_name,
                 options_from_collection_for_select(
                   column[:name].classify.constantize.distinct.order(:name),
                   "id", "name", params[param_name]
                 ),
                 class: "form-control", include_blank: true
    end
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

end
