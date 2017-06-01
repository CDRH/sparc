class Admin::RoomTypesController < ApplicationController

  active_scaffold :room_type do |conf|
    conf.columns = [:description, :occupation, :location]
  end

  record_select :per_page => 10, :search_on => [:description, :occupation, :location]


end
