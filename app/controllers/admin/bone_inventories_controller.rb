class Admin::BoneInventoriesController < ApplicationController

  active_scaffold :bone_inventory do |conf|
    conf.columns = [:site, :units, :strata, :features, :fs, :box, :bone_inventory_count, :gridew, :gridns, :quad, :exactprov, :depthbeg, :depthend, :stratalpha, :strat_one, :strat_two, :othstrats, :field_date, :excavator, :art_type, :sano, :recordkey, :comments, :entby, :location]
    conf.update.columns = [:site, :fs, :box, :bone_inventory_count, :gridew, :gridns, :quad, :exactprov, :depthbeg, :depthend, :stratalpha, :strat_one, :strat_two, :othstrats, :field_date, :excavator, :art_type, :sano, :recordkey, :comments, :entby, :location]
    # conf.columns[:art_type].form_ui = :select
    conf.actions.swap :search, :field_search
  end

end
