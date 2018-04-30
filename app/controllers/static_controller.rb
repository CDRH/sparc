class StaticController < ApplicationController

  def about
    @section = "about"
  end

  def about_sub
    @section = "about"
    @subsection = params["name"]
  end

  def descendants
    @section = "descendants"
  end

end
