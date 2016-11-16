class Query::RoomTypesController < ApplicationController

  active_scaffold :room_type do |conf|
    conf.columns = [:description, :period, :location]
  end

  record_select :per_page => 10, :search_on => [:description, :period, :location]


end
