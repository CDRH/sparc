# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


if Unit.all.size < 1
  s = Roo::Excelx.new('xls/Unit Summary_CCHedits.xlsx')
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
      if units.size < 1
        puts "No Unit for #{row[0]}"
        unit = Unit.create(:unit_no => row[0])
      else
        unit = Unit.where(:unit_no => row[0]).first
      end
      es = ExcavationStatus.where(excavation_status: row[1]).first
      if !es
        es = ExcavationStatus.create(excavation_status: row[1])
      end
      uo = UnitOccupation.where(occupation: row[2]).first
      if !uo
        uo = UnitOccupation.create(occupation: row[2])
      end
      uc = UnitClass.where(unit_class: row[3]).first
      if !uc
        uc = UnitClass.create(unit_class: row[3])
      end
      s = Story.where(story: row[4]).first
      if !s
        s = Story.create(story: row[4])
      end
      ir = IntactRoof.where(intact_roof: row[5]).first
      if !ir
        ir = IntactRoof.create(intact_roof: row[5])
      end
      ss = SalmonSector.where(salmon_sector: row[9]).first
      if !ss
        ss = SalmonSector.create(salmon_sector: row[9])
      end
      td = TypeDescription.where(type_description: row[7]).first
      if !td
        td = TypeDescription.create(type_description: row[7])
      end
      ifn = InferredFunction.where(inferred_function: row[8]).first
      if !ifn
        ifn = InferredFunction.create(inferred_function: row[8])
      end
      is = IrregularShape.where(irregular_shape: row[1]).first
      if !is
        is = IrregularShape.create(irregular_shape: row[1])
      end
    
      unit.update_columns(excavation_status_id: es.id, unit_occupation_id: uo.id, unit_class_id: uc.id, story_id: s.id, intact_roof_id: ir.id, room_type_id: row[6] != 'n/a' ? row[6].to_i : nil, type_description_id: td.id , inferred_function_id: ifn.id, salmon_sector_id: ss.id, other_description: row[10], irregular_shape_id: is.id, length: row[12], width: row[13], floor_area: row[14], comments: row[15])
    end

  end
end

if Stratum.all.size < 1
  s = Roo::Excel.new('xls/Strata.xls')

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
      units = Unit.where(:unit_no => row[0])
      if units.size < 1
        puts "No Unit for #{row[0]}"
        unit = Unit.create(:unit_no => row[0])
      else
        unit = Unit.where(:unit_no => row[0]).first
      end
      strata = Stratum.where(:unit_id => unit.id, strat_all: row[1])
      if strata.size < 1
        puts "No Stratum for #{row[0]} #{row[1]}"
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
  s = Roo::Excel.new('xls/Features_CCHedits.xls')


  s.sheet('Data').each do |row|
    if row[0] != 'Room'

      fo = FeatureOccupation.where(occupation: row[8]).first
      if !fo
        fo = FeatureOccupation.create(occupation: row[8])
      end
      ft = FeatureType.where(feature_type: row[9]).first
      if !ft
        ft = FeatureType.create(feature_type: row[9])
      end
      fg = FeatureGroup.where(feature_group: row[11]).first
      if !fg
        fg = FeatureGroup.create(feature_group: row[11])
      end
      rf = ResidentualFeature.where(residentual_feature: row[12]).first
      if !rf
        rf = ResidentualFeature.create(residentual_feature: row[12])
      end
      td = TShapedDoor.where(t_shaped_door: row[14]).first
      if !td
        td = TShapedDoor.create(t_shaped_door: row[14])
      end
      dm = DoorBetweenMultipleRoom.where(door_between_multiple_rooms: row[15]).first
      if !dm
        dm = DoorBetweenMultipleRoom.create(door_between_multiple_rooms: row[15])
      end
      ds = DoorwaySealed.where(doorway_sealed: row[16]).first
      if !ds
        ds = DoorwaySealed.create(doorway_sealed: row[16])
      end
      Feature.create(unit_no: row[0], feature_no: row[1], strat: row[2], floor_association: row[3], other_associated_features: row[5], grid: row[6], depth_m_b_d: row[7], feature_occupation_id: fo != nil ? fo.id : nil, feature_type_id: ft ? ft.id : nil, feature_count: row[10], feature_group_id: fg ? fg.id : nil, residentual_feature_id: rf ? rf.id : nil, location_in_room: row[13], t_shaped_door_id: td ? td.id : nil, door_between_multiple_room_id: dm ? dm.id : nil, doorway_sealed_id: ds ? ds.id : nil, length: row[17], width: row[18], depth_height: row[19], comments: row[20], feature_form: row[4])
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
          puts "create Unit #{f.unit_no}"
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
  s = Roo::Excelx.new('xls/Bone tool DB.xlsx')

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
  s = Roo::Excel.new('xls/Eggshell_CCHedits.xls')


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