require 'roo'
require 'pg'
require 'active_record' 
require 'byebug'
ActiveRecord::Base.establish_connection( 
:adapter => "postgresql", 
:username => "rwb3y", 
:password => "", 
:database => "sparc_data" 
) 

def PGconn.quote_ident(name)
    %("#{name}")
end

class Room < ActiveRecord::Base
  # has_many :codexes
end

class Codex < ActiveRecord::Base
  # belongs_to :room
end

class Feature < ActiveRecord::Base
  # belongs_to :room
end

class RoomType < ActiveRecord::Base
end

 # s = Roo::Excel.new('Codex.xls')
 s = Roo::Excel.new('Strata-07-25-16.xls')


 s.sheet('data').each do |row|
   if row[0] != 'ROOM'
     if Room.where(:room_no => row[0]).size < 1
       room = Room.create(:room_no => row[0])
     else
       room = Room.where(:room_no => row[0]).first
     end
     # Codex.create(room_no: row[0], unit_type: row[1], strat_all: row[2], strat_alpha: row[3], stratum_one: row[6], stratum_two: row[7], alias_strats: row[8], original_period: row[9], dominant_occupation: row[10], comments: row[11], room_id: room.id)
     Codex.create(room_no: row[0], strat_all: row[1], strat_alpha: row[2], stratum_one: row[3], stratum_two: row[4], dominant_occupation: row[5], comments: row[6], room_id: room.id)
   end
 end

 s = Roo::Excel.new('RoomSize.xls')


 s.sheet('DATA').each do |row|
   if row[0] != 'Room No.'
     rooms = Room.where(:room_no => row[0])
     if rooms.size < 1
       puts "No Unit for #{row[0]}"
       room = Room.create(:room_no => row[0])
     else
       room = Room.where(:room_no => row[0]).first
     end
     room.update_columns(excavation_status: row[1], occupation: row[2], room_class: row[3], stories: row[4], intact_roof: row[5], room_type_id: row[6], type_description: row[7], inferred_function: row[8], salmon_sector: row[9], other_desc: row[10], irregular_shape: row[11], length_text: row[12], width_text: row[13], floor_area_text: row[14], comments: row[15])
   end

 end

 s = Roo::Excelx.new('Unit_Summary.xlsx')


 s.sheet('data').each do |row|
   if row[0] != 'Unit No.'
     rooms = Room.where(:room_no => row[0])
     if rooms.size < 1
       puts "No Unit for #{row[0]}"
       room = Room.create(:room_no => row[0])
     else
       room = Room.where(:room_no => row[0]).first
     end
     room.update_columns(excavation_status: row[1], occupation: row[2], room_class: row[3], stories: row[4], intact_roof: row[5], room_type_id: row[6], type_description: row[7], inferred_function: row[8], salmon_sector: row[9], other_desc: row[10], irregular_shape: row[11], length_text: row[12], width_text: row[13], floor_area_text: row[14], comments: row[15])
   end

 end
 s.sheet('room typology').each do |row|
   if row[0] != 'Type No.'
     room_type = RoomType.where(id: row[0].to_i)
     if room_type.size == 0
       room_type = RoomType.create(:id => row[0].to_i, :description => row[1], :period => row[2], :location => row[3])
     end
   end

 end
 
 s = Roo::Excel.new('Features-07-25-16.xls')
 
 
 s.sheet('Data').each do |row|
   if row[0] != 'Room'
     # rooms = Room.where(:room_no => row[0])
     # if rooms.size < 1
     #   puts "No Room for #{row[0]}"
     #   room = Room.create(:room_no => row[0])
     # else
     #   room = Room.where(:room_no => row[0]).first
     # end
     Feature.create(room_no: row[0], feature_no: row[1], strat: row[2], floor_association: row[3], other_associated_features: row[5], grid: row[6], depth_m_b_d: row[7], occupation: row[8], feature_type: row[9], feature_count: row[10], feature_group: row[11], residentual_feature: row[12], location_in_room: row[13], t_shaped_door: row[14], door_between_multiple_rooms: row[15], doorway_sealed: row[16], length_text: row[17], width_text: row[18], depth_height_text: row[19], comments: row[20], feature_form: row[4])
   end
   
 end