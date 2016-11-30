module ImageHelper

  # default to true if not otherwise marked
  def human_remains? code
    code == "N" ? false : true
  end
  
end
