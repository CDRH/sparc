# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

files = {
  bonetools: 'xls/Bone_tool_DB.xlsx',
  eggshells: 'xls/Eggshell_CCHedits.xls',
  features: 'xls/Features_CCHedits.xls',
  strata: 'xls/Strata.xls',
  units: 'xls/Unit_Summary_CCHedits.xlsx',
}

def create_if_not_exists model, field, column
  record = model.where(field => column).first
  record = model.create(field => column) if !record
  return record
end

if Unit.all.size < 1
  s = Roo::Excelx.new(files[:units])
  s.sheet('room typology').each do |row|
    if row[0] != 'Type No.'
      room_type = RoomType.where(id: row[0].to_i)
      if room_type.size == 0
        room_type = RoomType.create(:id => row[0].to_i, :description => row[1], :period => row[2], :location => row[3])
      end
    end

  end

  s.sheet('data').each do |row|
    if row[0] != 'Unit No.'
      units = Unit.where(:unit_no => row[0])
      # TODO does this mean that there may be multiple units with the same "unit_no" ?
      # but we are only going to add to the first instance?
      # if there should only be one, we could use
      # `Unit.find_or_create_by(unit_no: row[0])`
      if units.size < 1
        puts "No Unit for #{row[0]}"
        unit = Unit.create(:unit_no => row[0])
      else
        unit = Unit.where(:unit_no => row[0]).first
      end
      u = {}
      u[:excavation_status] = create_if_not_exists(ExcavationStatus, :excavation_status, row[1])
      u[:unit_occupation] = create_if_not_exists(UnitOccupation, :occupation, row[2])
      u[:unit_class] = create_if_not_exists(UnitClass, :unit_class, row[3])
      u[:story] = create_if_not_exists(Story, :story, row[4])
      u[:intact_roof] = create_if_not_exists(IntactRoof, :intact_roof, row[5])
      u[:salmon_sector] = create_if_not_exists(SalmonSector, :salmon_sector, row[9])
      u[:type_description] = create_if_not_exists(TypeDescription, :type_description, row[7])
      u[:inferred_function] = create_if_not_exists(InferredFunction, :inferred_function, row[8])
      u[:irregular_shape] = create_if_not_exists(IrregularShape, :irregular_shape, row[1])
      u[:room_type_id] = row[6] != 'n/a' ? row[6].to_i : nil
      u[:other_description] = row[10]
      u[:length] = row[12]
      u[:width] = row[13]
      u[:floor_area] = row[14]
      u[:comments] = row[15]
      unit.update(u)
    end

  end
end

if Stratum.all.size < 1
  s = Roo::Excel.new(files[:strata])

  s.sheet('strat descp').each do |row|
    if row[0] != 'CODE'
      strat_type = StratType.where(code: row[0])
      if strat_type.size == 0
        strat_type = StratType.create(code: row[0], strat_type: row[1])
      end
    end
  end

  s.sheet('data').each do |row|
    if row[0] != 'ROOM'
      # TODO same note here as above, can there be more than one with unit_no?
      units = Unit.where(:unit_no => row[0])
      if units.size < 1
        puts "Creating Unit for #{row[0]}"
        unit = Unit.create(:unit_no => row[0])
      else
        unit = Unit.where(:unit_no => row[0]).first
      end
      strata = Stratum.where(:unit_id => unit.id, strat_all: row[1])
      if strata.size < 1
        puts "Creating Stratum for #{row[0]} #{row[1]}"
        stratum = Stratum.create(:unit_id => unit.id, strat_all: row[1])
      else
        stratum = Stratum.where(:unit_id => unit.id, strat_all: row[1]).first
      end
      st = StratType.where(code: row[2]).first
      so = StratOccupation.where(occupation: row[5]).first
      if !so
        so = StratOccupation.create(occupation: row[5])
      end
     
      stratum.update_columns(strat_all: row[1], strat_alpha: row[2], strat_type_id: st != nil ? st.id : nil, stratum_one: row[3], stratum_two: row[4], strat_occupation_id: so.id, comments: row[6])
    end

  end

end

if Feature.all.size < 1
  s = Roo::Excel.new(files[:features])

  s.sheet('Data').each do |row|
    if row[0] != 'Room'
      fo = create_if_not_exists(FeatureOccupation, :occupation, row[8])
      ft = create_if_not_exists(FeatureType, :feature_type, row[9])
      fg = create_if_not_exists(FeatureGroup, :feature_group, row[11])
      rf = create_if_not_exists(ResidentualFeature, :residentual_feature, row[12])
      td = create_if_not_exists(TShapedDoor, :t_shaped_door, row[14])
      dm = create_if_not_exists(DoorBetweenMultipleRoom, :door_between_multiple_rooms, row[15])
      ds = create_if_not_exists(DoorwaySealed, :doorway_sealed, row[16])
      Feature.create(
        unit_no: row[0],
        feature_no: row[1],
        strat: row[2],
        floor_association: row[3],
        other_associated_features: row[5],
        grid: row[6], depth_m_b_d: row[7],
        feature_occupation: fo != nil ? fo : nil,
        feature_type: ft ? ft : nil,
        feature_count: row[10],
        feature_group: fg ? fg : nil,
        residentual_feature: rf ? rf : nil,
        location_in_room: row[13],
        t_shaped_door: td ? td : nil,
        door_between_multiple_room: dm ? dm : nil,
        doorway_sealed: ds ? ds : nil,
        length: row[17],
        width: row[18],
        depth_height: row[19],
        comments: row[20],
        feature_form: row[4]
      )
    end
  end

  Feature.all.each do |f|
    a = f.strat.to_s.gsub(';',',').split(',').map{|o| o.strip}
    # a.uniq!
    a.each do |o|
      c = nil
        r = Unit.where(unit_no:f.unit_no).first
        if r == nil
          r = Unit.create(unit_no:f.unit_no, comments: 'imported from feature')
          puts "create Unit #{f.unit_no} from feature #{f.id}"
        end
        s = Stratum.where(strat_all: o, unit_id: r.id).first
        if s == nil
          s = Stratum.create(strat_all: o, unit_id: r.id, comments: 'imported none')
          puts "create Strata #{f.unit_no} #{o}"
        end
        Feature.where(id: f.id).first.strata << s
    end
  end
end

if BoneTool.all.size < 1
  s = Roo::Excelx.new(files[:bonetools])

  puts 'Loading Bonetools'
  
  s.sheet('data').each do |row|
    room = nil
    if row[0] != 'Room'
      if row[0] != 'no data' and !row[0].include?(' ')
        if Unit.where(:unit_no => row[0]).size < 1
          room = Unit.create(:unit_no => row[0])
          puts "creating Unit #{row[0]}"
        else
          room = Unit.where(:unit_no => row[0]).first
        end
      else
        if Unit.where(:unit_no => 'Other').size < 1
          room = Unit.create(:unit_no => 'Other')
          puts "creating Unit Other for #{row[0]}"
        else
          room = Unit.where(:unit_no => 'Other').first
          puts "using Unit Other for #{row[0]}"
        end
       
      end
      o = BoneToolOccupation.where(occupation: row[4]).first
      if !o
        o = BoneToolOccupation.create(occupation: row[4])
      end
      b = BoneTool.create(room: row[0], strat: row[1], field_specimen_no: row[2], depth: row[3], bone_tool_occupation_id: o.id, grid: row[5], tool_type_code: row[6], tool_type: row[7] , species_code: row[8], comments: row[9])
     
      a = b.strat.to_s.gsub(';',',').split(',').map{|o| o.strip}
      a.each do |o|
        s = Stratum.where(strat_all: o, unit_id: room.id).first
        if s == nil
          s = Stratum.create(strat_all: o, unit_id: room ? room.id : nil, comments: 'imported none')
          puts "create Stratum #{row[0]} (#{room.unit_no}) #{o}"
        end
        # f = s.features.where(feature_no: row[2]).first
        # if !f
        #   f = Feature.create(feature_no: row[2])
        #   f.strata << s
        # else
        #   if !f.strata.include?(s)
        #     f.strata << s
        #   end
        # end
        b.strata << s
      end
    end
  end

end

if Eggshell.all.size < 1
  puts 'Loading Eggshells...'
  s = Roo::Excel.new(files[:eggshells])


  s.sheet('eggshell').each do |row|
    room = nil
    if row[0] != 'Room'
      if row[0] != 'no data' and !row[0].include?(' ')
        if Unit.where(:unit_no => row[0]).size < 1
          room = Unit.create(:unit_no => row[0])
          puts "creating Unit #{row[0]}"
        else
          room = Unit.where(:unit_no => row[0]).first
        end
      else
        if Unit.where(:unit_no => 'Other').size < 1
          room = Unit.create(:unit_no => 'Other')
          puts "creating Unit Other for #{row[0]}"
        else
          room = Unit.where(:unit_no => 'Other').first
          puts "using Unit Other for #{row[0]}"
        end
       
      end
      ea = nil
      if row[11]
        ea = EggshellAffiliation.where(affiliation: row[11]).first
        if !ea
          ea = EggshellAffiliation.create(affiliation: row[11])
        end
      end
      ei = nil
      if row[12]
        ei = EggshellItem.where(item: row[12]).first
        if !ei
          ei = EggshellItem.create(item: row[12])
        end
      end
      e = Eggshell.create(room: row[0], strat: row[1], salmon_museum_id_no: row[2], record_field_key_no: row[3], grid: row[4], quad: row[5], depth: row[6], feature_no: row[7] , storage_bin: row[8], museum_date: row[9], field_date: row[10], eggshell_affiliation_id: ea != nil ? ea.id : nil, eggshell_item_id: ei != nil ? ei.id : nil)
     
      a = e.strat.to_s.gsub(';',',').split(',').map{|o| o.strip}
      a.each do |o|
        s = Stratum.where(strat_all: o, unit_id: room.id).first
        if s == nil
          s = Stratum.create(strat_all: o, unit_id: room ? room.id : nil, comments: 'imported none')
          puts "create Stratum #{row[0]} (#{room.unit_no}) #{o}"
        end
        i = row[7].rindex(/[A-Z]/)
        if row[7]
          if row[7] == 'none'
            fn = 'none'
          else
            unit = row[7][0,i+1]
            fn = row[7][i+1,row[7].size-1].to_f
          end
          puts "find feature #{fn}"
          f = s.features.where(feature_no: fn).first
          if !f
            f = Feature.create(feature_no: fn)
            f.strata << s
          else
            if !f.strata.include?(s)
              f.strata << s
            end
          end
          e.features << f
        end
      end
    end
  end


end
