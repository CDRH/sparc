class Admin::ZonesController < ApplicationController

  active_scaffold :zone do |conf|
    conf.columns = [:name, :comments, :units]
    conf.update.columns = [:name, :comments]
    conf.columns[:units].form_ui = :record_select
    conf.actions.swap :search, :field_search
  end

end
