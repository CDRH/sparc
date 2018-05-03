class StaticController < ApplicationController

  def about
    @section = "about"
  end

  # this action uses part of the URL to determine which partial to pull in dynamically
  # to add more about pages, simply create a partial with the name as you would like it to
  # appear in the URL and add the page to the subnavigation

  def about_sub
    @section = "about"
    @subsection = params["name"]
  end

  def descendants
    @section = "descendants"
  end

end
