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

class CodexFeature < ActiveRecord::Base
  # has_many :codexes
end

class Codex < ActiveRecord::Base
  has_many :codex_features
  has_many :features, :through => :codex_features
  # belongs_to :room
end

class Feature < ActiveRecord::Base
  has_many :codex_features
  has_many :codexes, :through => :codex_features
  
end

Feature.all.each do |f|
  
  a = f.strat.to_s.gsub(';',',').split(',').map{|o| o.strip}
  # a.uniq!
  a.each do |o|
    c = nil
    # if o != 'none' and o != 'no info'
    #   c = Codex.where(strat_all: o, room_no: f.room_no).first
    # else
      r = Room.where(room_no:f.room_no).first
      if r == nil
        r = Room.create(room_no:f.room_no, comments: 'imported from feature')
        puts "create Room #{f.room_no}"
      end
      c = Codex.where(strat_all: o, room_no: f.room_no).first
      if c == nil
        c = Codex.create(strat_all: o, room_no: f.room_no, room_id: r.id, comments: 'imported none')
        puts "create Codex #{f.room_no} #{o}"
      end
    # end
    if c != nil
      CodexFeature.create(codex_id: c.id, feature_id: f.id)
    else
      r = Room.create(room_no:f.room_no, comments: 'imported from feature')
      puts "create Room #{f.room_no}"
      c = Codex.create(strat_all: o, room_no: f.room_no, room_id: r.id, comments: 'imported none')
      puts "create Codex #{f.room_no} #{o}"
      
      # puts "Codex #{f.room_no} #{o} doesn't exist"
    end
  end
end