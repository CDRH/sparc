# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

################
# Spreadsheets #
################

files = {
  bonetools: 'xls/Bone_tool_DB.xlsx',
  eggshells: 'xls/Eggshell_CCHedits.xls',
  features: 'xls/Features_CCHedits.xls',
  ornaments: 'xls/Ornament_DB_CCHedits.xlsx',
  perishables: 'xls/Perishables_CCHedits.xls',
  select_artifacts: 'xls/Select_Artifacts.xls',
  soils: 'xls/Soil_Master.xlsx',
  strata: 'xls/Strata.xls',
  units: 'xls/Unit_Summary_CCHedits.xlsx',
}

# will contain an array of hashes
# with items that need to be hand checked
# (for example, a unit number in the soils spreadsheet that is brand new)
@handcheck = []

###########
# Helpers #
###########

# given a specific unit with a list of strata and features, find or create
# all the items and create appropriate relationships
# returns the features
#   unit has many strata which have many features
#   feature is uniquely identified by unit, stratum, and feature_no
def associate_strata_features unit, aStrata, aFeatures, related_item, source
  # pull out all of the strata from a single column
  strata = aStrata.split(/[;,]/).map { |s| s.strip }
  strata.each do |strat_no|
    stratum = Stratum.where(strat_all: strat_no, unit_id: unit.id).first
    # create if stratum does not yet exist for a specific unit
    if stratum.nil?
      puts "creating Stratum #{unit.unit_no}:#{strat_no} for #{source}"
      @handcheck << { type: "stratum", num: "#{unit.unit_no}:#{strat_no}", source: source }
      stratum = Stratum.create(
        strat_all: strat_no,
        unit_id: unit.id,
        comments: "imported from #{source}"
      )
    end
    # pull out all of the features from a single column
    features = aFeatures.split(/[;,]/).map { |f| f.strip }
    features.each do |feat_no|
      # at this point the given stratum should be associated with a specific unit, so
      # only verifying that the feature_no is not in the stratum
      feature = stratum.features.where(feature_no: feat_no).first
      if !feature
        feature = Feature.create(
          feature_no: feat_no,
          unit_no: unit.unit_no,
          comments: "imported from #{source}"
        )
        @handcheck << { type: "feature", num: "#{unit.unit_no}:#{strat_no}:#{feat_no}", source: source}
        puts "creating feature #{unit.unit_no}:#{strat_no}:#{feat_no} for #{source}"
      end
      # associate the feature with the strata
      # associate the feature with the specific record (ornament, perishable, etc)
      stratum.features << feature unless stratum.features.include?(feature)
      if related_item
        related_item.features << feature unless related_item.features.include?(feature)
      end
    end
  end
end

def create_if_not_exists model, field, column
  record = model.where(field => column).first
  record = model.create(field => column) if !record
  return record
end

def convert_empty_to_none entry
  return entry.map do |field|
    (field.nil? || field == "") ? "none" : field
  end
end

def get_feature_number longnum, source
  feature = nil
  if longnum == "no data" || longnum == "none"
    feature = longnum
  else
    begin
      # cut off the unit part of the id:
      # "014P002" or "014P-002" and turn to float "2.0"
      feature = longnum.split(/[A-Z\-]/).last.to_f
    rescue
      puts "Unable to parse feature #{longnum} from #{source}"
      @handcheck << { type: "feature", num: longnum, source: source }
    end
  end
  return feature
end

def select_or_create_unit unit, spreadsheet
  room = nil
  if unit != 'no data' and !unit.include?(' ')
    if Unit.where(:unit_no => unit).size < 1
      room = Unit.create(:unit_no => unit)
      puts "creating Unit #{unit} from #{spreadsheet}"
      @handcheck << { type: "unit", num: "#{unit}", source: "#{spreadsheet}" }
    else
      room = Unit.where(:unit_no => unit).first
    end
  else
    if Unit.where(:unit_no => 'Other').size < 1
      room = Unit.create(:unit_no => 'Other')
      puts "creating Unit Other for #{unit}"
    else
      room = Unit.where(:unit_no => 'Other').first
      puts "using Unit Other for #{unit}"
    end
  end
  return room
end

#########
# Units #
#########

if Unit.all.size < 1
  s = Roo::Excelx.new(files[:units])
  s.sheet('room typology').each do |row|
    if row[0] != 'Type No.'
      room_type = RoomType.where(id: row[0].to_i)
      if room_type.size == 0
        room_type = RoomType.create(
          :id => row[0].to_i,
          :description => row[1],
          :location => row[3],
          :period => row[2]
        )
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
        puts "Creating unit for #{row[0]}"
        unit = Unit.create(:unit_no => row[0])
      else
        unit = Unit.where(:unit_no => row[0]).first
      end
      u = {}
      u[:comments] = row[15]
      u[:excavation_status] = create_if_not_exists(ExcavationStatus, :excavation_status, row[1])
      u[:floor_area] = row[14]
      u[:inferred_function] = create_if_not_exists(InferredFunction, :inferred_function, row[8])
      u[:intact_roof] = create_if_not_exists(IntactRoof, :intact_roof, row[5])
      u[:irregular_shape] = create_if_not_exists(IrregularShape, :irregular_shape, row[1])
      u[:length] = row[12]
      u[:other_description] = row[10]
      u[:room_type_id] = row[6] != 'n/a' ? row[6].to_i : nil
      u[:salmon_sector] = create_if_not_exists(SalmonSector, :salmon_sector, row[9])
      u[:story] = create_if_not_exists(Story, :story, row[4])
      u[:type_description] = create_if_not_exists(TypeDescription, :type_description, row[7])
      u[:unit_class] = create_if_not_exists(UnitClass, :unit_class, row[3])
      u[:unit_occupation] = create_if_not_exists(UnitOccupation, :occupation, row[2])
      u[:width] = row[13]
      unit.update(u)
    end

  end
end

##########
# Strata #
##########

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
        puts "Creating Unit for stratum #{row[0]}"
        @handcheck << { type: "unit", num: row[0], source: "stratum #{row[1]}" }
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

############
# Features #
############

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
        comments: row[20],
        depth_height: row[19],
        door_between_multiple_room: dm ? dm : nil,
        doorway_sealed: ds ? ds : nil,
        grid: row[6], depth_m_b_d: row[7],
        feature_count: row[10],
        feature_form: row[4],
        feature_group: fg ? fg : nil,
        feature_no: row[1],
        feature_occupation: fo != nil ? fo : nil,
        feature_type: ft ? ft : nil,
        floor_association: row[3],
        length: row[17],
        location_in_room: row[13],
        other_associated_features: row[5],
        residentual_feature: rf ? rf : nil,
        strat: row[2],
        t_shaped_door: td ? td : nil,
        unit_no: row[0],
        width: row[18]
      )
    end
  end

  Feature.all.each do |f|
    a = f.strat.to_s.gsub(';',',').split(',').map{|o| o.strip}
    # a.uniq!
    a.each do |o|
      r = Unit.where(unit_no:f.unit_no).first
      if r.nil?
        r = Unit.create(unit_no:f.unit_no, comments: 'imported from feature')
        puts "create Unit #{f.unit_no} from feature #{f.id}"
        @handcheck << { type: "unit", num: "#{f.unit_no}", source: "feature #{f.id}" }
      end
      s = Stratum.where(strat_all: o, unit_id: r.id).first
      if s.nil?
        s = Stratum.create(strat_all: o, unit_id: r.id, comments: 'imported none')
        puts "create stratum #{f.unit_no} #{o}"
        @handcheck << { type: "stratum", num: "#{f.unit_no}:#{o}", source: "feature #{f.id}" }
      end
      f.strata << s
    end
  end
end

#############
# BoneTools #
#############

if BoneTool.all.size < 1
  s = Roo::Excelx.new(files[:bonetools])
  puts 'Loading Bonetools'
  
  s.sheet('data').each do |row|
    room = nil
    if row[0] != 'Room'
      room = select_or_create_unit(row[0], 'bonetools')

      o = create_if_not_exists(BoneToolOccupation, :occupation, row[4])
      b = BoneTool.create(
        bone_tool_occupation: o,
        comments: row[9],
        depth: row[3],
        field_specimen_no: row[2],
        grid: row[5],
        room: row[0],
        species_code: row[8],
        strat: row[1],
        tool_type: row[7],
        tool_type_code: row[6]
      )
     
      a = b.strat.to_s.gsub(';', ',').split(',').map{|bstrat| bstrat.strip}
      a.each do |strats|
        s = Stratum.where(strat_all: strats, unit_id: room.id).first
        if s.nil?
          puts "creating Stratum #{strats} (#{room.unit_no}) #{strats}"
          @handcheck << { type: "stratum", num: "#{room.unit_no}:#{row[0]}", source: "bonetool #{b.id}" }
          s = Stratum.create(
            strat_all: strats,
            unit_id: room ? room.id : nil,
            comments: 'imported none'
          )
        end
        b.strata << s
      end
    end
  end

end

#############
# Eggshells #
#############

if Eggshell.all.size < 1
  puts 'Loading Eggshells...'
  s = Roo::Excel.new(files[:eggshells])

  s.sheet('eggshell').each do |row|
    room = nil
    if row[0] != 'Room'
      room = select_or_create_unit(row[0], 'eggshells')

      ea = nil
      if row[11]
        ea = create_if_not_exists(EggshellAffiliation, :affiliation, row[11])
      end
      ei = nil
      if row[12]
        ei = create_if_not_exists(EggshellItem, :item, row[12]) if row[12]
      end
      e = Eggshell.create(
        depth: row[6],
        eggshell_affiliation: ea.nil? ? nil : ea,
        eggshell_item: ei.nil? ? nil : ei,
        feature_no: row[7],
        field_date: row[10],
        grid: row[4],
        museum_date: row[9],
        quad: row[5],
        record_field_key_no: row[3],
        room: row[0],
        salmon_museum_id_no: row[2],
        storage_bin: row[8],
        strat: row[1],
      )
     
      associate_strata_features(room, row[1], row[7], e, "eggshell")
    end
  end
end

#########
# Soils #
#########

if Soil.all.size < 1
  puts 'Loading Soils...'
  s = Roo::Excelx.new(files[:soils])

  s.sheet('Sheet1').each do |entry|
    # empty fields should say "none" to standardize
    row = entry.map{ |field| (field.nil? || field == "") ? "none" : field }

    if row[0] != 'SITE'
      soil = {}
      soil[:box] = row[5]
      soil[:comments] = row[19]
      soil[:data_entry] = row[20]
      soil[:date] = row[15]
      soil[:depthbeg] = row[12]
      soil[:depthend] = row[13]
      soil[:exactprov] = row[11]
      soil[:excavator] = row[16]
      soil[:feature_key] = row[3]
      soil[:fs] = row[4]
      soil[:gridew] = row[8]
      soil[:gridns] = row[9]
      soil[:location] = row[21]
      soil[:otherstrat] = row[14]
      soil[:period] = row[6]
      soil[:quad] = row[10]
      soil[:sample_no] = row[18]
      soil[:site] = row[0]
      soil[:soil_count] = row[7]
      soil[:strat] = row[2]

      soil[:art_type_id] = create_if_not_exists(ArtType, :art_type, row[17]).id

      # TODO there is not actually an association between soils and units, this is just a string
      # though it will make a NEW unit if one didn't previously exist
      # could assign strata to new unit
      unit = select_or_create_unit(row[1], 'soils')
      soil[:room] = unit.unit_no

      soil_row = Soil.create(soil)
      associate_strata_features(unit, row[2], row[3], soil_row, "soil")
    end
  end
end

###############
# Perishables #
###############

# NOTE:  Perishables may belong to more than one unit

if Perishable.all.size < 1
  puts 'Loading Perishables...'
  s = Roo::Excel.new(files[:perishables])

  s.sheet('all').each do |entry|
    # empty fields should say "none" to standardize
    row = convert_empty_to_none(entry)

    if row[0] != 'FS Number'
      perish = {}
      perish[:fs_number] = row[0]
      perish[:salmon_museum_number] = row[1]
      # Note: room is being saved as the string from the spreadsheet
      perish[:room] = row[2]
      perish[:grid] = row[4]
      perish[:quad] = row[5]
      perish[:depth] = row[6]
      perish[:sa_no] = row[9]
      perish[:artifact_type] = row[10]
      perish[:perishable_count] = row[11]
      perish[:artifact_structure] = row[12]
      perish[:comments] = row[13]
      perish[:other_comments] = row[14]
      perish[:storage_location] = row[15]
      # TODO not sure what column to use for this
      # perish[:object_structure] = row[16]
      perish[:exhibit_location] = row[16]
      perish[:record_key_no] = row[17]
      perish[:museum_lab_no] = row[18]
      perish[:field_date] = row[19]
      perish[:original_analysis] = row[20]

      # period
      perish[:perishable_period_id] = create_if_not_exists(PerishablePeriod, :period, row[8]).id

      perish_row = Perishable.create(perish)

      # TODO perishables have more than one unit, what to do in that case?
      # unit = select_or_create_unit(row[2], 'perishables')
      # TODO strata and features after hearing back about unit info
      # strata is row[3]
      # features is row[7]
    end
  end
end

#############
# Ornaments #
#############

if Ornament.all.size < 1
  puts 'Loading Ornaments...'
  s = Roo::Excelx.new(files[:ornaments])

  s.sheet('data').each do |entry|
    # empty fields should say "none" to standardize
    row = convert_empty_to_none(entry)

    if row[0] != 'Museum Specimen No.'
      orna = {}
      orna[:museum_specimen_no] = row[0]
      orna[:analysis_lab_no] = row[1]
      orna[:room] = row[2]
      orna[:grid] = row[4]
      orna[:quad] = row[5]
      orna[:depth] = row[6]
      orna[:field_date] = row[7]
      orna[:analyst] = row[10]
      orna[:analyzed] = row[11]
      orna[:photographer] = row[12]
      orna[:count] = row[13]
      orna[:item] = row[14]

      stratum = create_if_not_exists(Stratum, :strat_all, row[3])
      orna[:strat] = stratum.id

      feature_no = get_feature_number(row[9], "ornaments")
      feature = Feature.where(feature_no: feature, unit_no: orna[:room]).first
      if feature.nil?
        feature = Feature.create(
          unit_no: orna[:room],
          feature_no: feature_no
        )
        feature.strata << stratum
      end
      orna[:feature] = feature
      orna[:ornament_period_id] = create_if_not_exists(OrnamentPeriod, :period, row[8]).id

      # should already have the stratum and feature related, so we're done!
      Ornament.create(orna)
    end
  end
end


####################
# Select Artifacts #
####################

if SelectArtifact.all.size < 1
  puts 'Loading Select Artifacts...'
  s = Roo::Excel.new(files[:select_artifacts])

  s.sheet('main data').each do |entry|
    # empty fields should say "none" to standardize
    row = convert_empty_to_none(entry)

    if row[0] != 'Room'
      sa = {}
      sa[:artifact_no] = row[1]
      # sa[:strat] = row[2]
      sa[:floor_association] = row[3]
      sa[:sa_form] = row[4]
      # TODO verify that the below is not "features"
      sa[:associated_feature_artifacts] = row[5]
      sa[:grid] = row[6]
      sa[:depth] = row[7]
      sa[:select_artifact_occupation_id] = create_if_not_exists(SelectArtifactOccupation, :occupation, row[8]).id
      sa[:select_artifact_type] = row[9]
      sa[:artifact_count] = row[10]
      sa[:location_in_room] = row[11]
      sa[:comments] = row[12]

      unit = select_or_create_unit(row[0], "select artifacts")
      sa[:room] = unit.unit_no

      select_artifact = SelectArtifact.create(sa)

      sa_strata = row[2].split(/[,;]/).map{ |stratum| stratum.strip }
      sa_strata.each do |sa_str|
        stratum = Stratum.where(strat_all: sa_str, unit_id: unit.id).first
        if stratum.nil?
          puts "creating stratum #{sa_str} for select artifacts"
          @handcheck << { type: "stratum", num: "#{unit.id}:#{sa_str}", source: "select artifacts" }
          stratum = Stratum.create(
            strat_all: sa_str,
            unit: unit,
            comments: 'imported from select artifacts spreadsheet'
          )
        end
        select_artifact.strata << stratum
      end
    end
  end
end


File.open("please_check_for_accuracy.txt", "w") do |file|
  file.write("Please review the following and verify that units, strata, etc, were added correctly\n")
  @handcheck.each do |added|
    file.write("\n#{added[:type]} number #{added[:num]} was added from the #{added[:source]} spreadsheet")
  end
end
