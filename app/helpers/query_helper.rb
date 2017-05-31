module QueryHelper

  def checked? value, paramlist
    if paramlist.blank?
      return false
    else
      return paramlist.include?(value.to_s)
    end
  end
end
