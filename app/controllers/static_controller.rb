class StaticController < ApplicationController

  def about
    @section = "about"
  end

  def descendants
    @section = "descendants"
  end

end
