module DocumentHelper

  def doc_type_active(type)
    type_name = type.name.parameterize('_')
    return type_name == @type ? "doc_type_active" : "" 
  end
  
end
