module ExploreHelper

  def tab_selected(current)
    "class=active" if current == @selected
  end
end
