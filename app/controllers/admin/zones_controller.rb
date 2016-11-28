class Admin::ZonesController < ApplicationController

  active_scaffold :zone do |conf|
    conf.columns = [:number, :comments, :units]
    conf.update.columns = [:number, :comments]
    conf.columns[:units].form_ui = :record_select
    conf.actions.swap :search, :field_search
  end

end
