# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

################
# Spreadsheets #
################

files = {
  # Primary Tables
  units: 'xls/Unit_Summary_CCHedits.xlsx',
  strata: 'xls/Strata.xls',
  features: 'xls/Features_CCHedits.xls',

  # Inventory Tables
  bone_inventory: 'xls/BoneInventory2016-CCH.xlsx',
  ceramic_inventory: 'xls/CeramicInventory2016.xlsx',
  lithic_inventory: 'xls/LithicInventory2016.xlsx',

  # Analysis Tables
  bonetools: 'xls/Bone_tool_DB.xlsx',
  eggshells: 'xls/Eggshell_CCHedits.xls',
  ornaments: 'xls/Ornament_DB_CCHedits.xlsx',
  perishables: 'xls/Perishables-CCHedits-Nov13-2016.xls',
  select_artifacts: 'xls/Select_Artifacts.xls',
  soils: 'xls/Soil_Master.xlsx',

  # Images
  images: 'xls/Images.xlsx'
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
  strata.uniq!
  strata.each do |strat_no|
    stratum = select_or_create_stratum(unit, strat_no, source)
    # pull out all of the features from a single column
    features = aFeatures.split(/[;,]/).map { |f| f.strip }
    features.uniq!
    features.each do |feat|
      feat_no = get_feature_number(feat, source)
      # at this point the given stratum should be associated with a specific unit, so
      # only verifying that the feature_no is not in the stratum
      feature = stratum.features.where(feature_no: feat_no).first
      if !feature
        feature = Feature.create(
          feature_no: feat_no,
          unit_no: unit.unit_no,
          comments: "imported from #{source}"
        )
        report "feature", "#{unit.unit_no}:#{strat_no}:#{feat_no}", source
      end
      # associate the feature with the strata
      # associate the feature with the specific record (ornament, perishable, etc)
      stratum.features << feature
      if related_item
        related_item[:features] << feature
      end
    end
  end
end

def create_if_not_exists model, field, column
  column = column.nil? ? "no data" : column.strip
  record = model.where(field => column).first
  record = model.create(field => column) if !record
  return record
end

def convert_empty_to_none entry
  return entry.map do |field|
    (field.nil? || field == "") ? "none" : field
  end
end

# Rename this after all sheets have been refactored
def convert_empty_hash_values_to_none entry_hash
  return entry_hash.each do |key, value|
    entry_hash[key] = "none" if value.blank?
  end
end

def find_or_create_and_log(source, model, **attributes)
  model.find_or_create_by(attributes) do |record|
    record.comments = "Imported from #{source}"
    report model, attributes.values.first, source
  end
end

def get_feature_number feat_str, source
  feature = nil
  if feat_str == "no data" || feat_str == "none"
    feature = feat_str
  elsif feat_str == "NO INFO" || feat_str == "no info"
    feature = "no data"
  else
    begin
      # cut off the unit part of the id:
      # "014P002" or "014P-002" and turn to float "2.0"
      feature = feat_str.split(/[A-Z\-]/).last.to_f
    rescue
      report "feature", feat_str, source
      puts "Unable to parse feature #{feat_str} from #{source}"
    end
  end
  return feature
end

def report category, value, source
  # filter out all of the stratum and features that are "none"
  # but keep those that might be attached TO a "none" stratum, unit, etc
  puts "Creating #{category} #{value} for #{source}"
  if !value.to_s.end_with?("none") && !value.to_s.end_with?("no data")
    @handcheck << {category: category, value: value, source: source}
  end
end

def select_or_create_stratum unit, strat_no, source
  stratum = Stratum.where(strat_all: strat_no, unit_id: unit.id).first
  # create if stratum does not yet exist for a specific unit
  if stratum.nil?
    report "stratum", "#{unit.unit_no}:#{strat_no}", source
    stratum = Stratum.create(
      strat_all: strat_no,
      unit_id: unit.id,
      comments: "imported from #{source}"
    )
  end
  return stratum
end

def select_or_create_unit unit, spreadsheet, log=true
  room = nil
  # some units have trailing spaces or are in the spreadsheet
  # as an integer field, which the roo gem preserves
  unit = unit.to_s.strip
  if unit != 'no data' and !unit.include?(' ')
    if Unit.where(:unit_no => unit).size < 1
      # extract the zone from the unit
      # and create zone if necessary
      zone = select_or_create_zone_from_unit unit, spreadsheet, log
      puts unit
      room = Unit.create(:unit_no => unit, :zone => zone)
      report "Unit", unit, spreadsheet if log
    else
      room = Unit.where(:unit_no => unit).first
    end
  else
    if Unit.where(:unit_no => "Other").size < 1
      zone = Zone.create(:number => "Other")
      room = Unit.create(:unit_no => "Other", :zone => zone)
      puts "Creating \"Other\" for #{unit}"
    else
      room = Unit.where(:unit_no => 'Other').first
      puts "Using \"Other\" for #{unit}"
    end
  end
  return room
end

def select_or_create_zone_from_unit unit_str, spreadsheet, log=true
  num = unit_str.sub(/^0*/, "").sub(/[A-Z\/]*$/, "")
  if Zone.where(:number => num).size < 1
    puts "\nZone #{num}:"
    report "Zone", num, spreadsheet if log
    return Zone.create(:number => num)
  else
    return Zone.where(:number => num).first
  end
end

##################
# PRIMARY TABLES #
##################

#########
# Units #
#########
def seed_units files
  s = Roo::Excelx.new(files[:units])

  puts "\n\n\nCreating Room Types\n"

  room_type_columns = {
    # Order as seen in spreadsheet
    id: "Type No.",
    description: "Description",
    period: "Period",
    location: "Location"
  }

  s.sheet('room typology').each(room_type_columns) do |row|
    # Skip header row
    next if row[:id] == "Type No."

    room_type = convert_empty_hash_values_to_none(row)

    room_type[:id] = room_type[:id].to_i
    next if RoomType.where(id: room_type[:id]).size > 0

    puts "\n#{room_type[:id]}"
    puts "  When  : #{room_type[:period]}"
    puts "  Where : #{room_type[:location]}"
    puts "  Descrp: #{room_type[:description]}"
    RoomType.create(room_type)
  end


  puts "\n\n\nCreating Units\n"

  unit_columns = {
    # Order as seen in spreadsheet
    unit_no: "Unit No.",
    excavation_status: "Excavation Status",
    unit_occupation: "Occupation",
    unit_class: "Class",
    story: "Stories",
    intact_roof: "Intact Roof",
    salmon_type_code: "Salmon Type Code",
    type_description: "Type Description",
    inferred_function: "Inferred Function",
    salmon_sector: "Salmon Sector",
    other_description: "Other Descrp",
    irregular_shape: "Irregular Shape",
    length: "Length",
    width: "Width",
    floor_area: "Floor Area",
    comments: "Comments"
  }

  s.sheet('data').each(unit_columns) do |row|
    # Skip header row
    next if row[:unit_no] == "Unit No."

    unit = convert_empty_hash_values_to_none(row)

    # Handle foreign key columns
    unit[:excavation_status] = create_if_not_exists(ExcavationStatus, :excavation_status, unit[:excavation_status])
    unit[:unit_occupation] = create_if_not_exists(UnitOccupation, :occupation, unit[:unit_occupation])
    unit[:unit_class] = create_if_not_exists(UnitClass, :unit_class, unit[:unit_class])
    unit[:story] = create_if_not_exists(Story, :story, unit[:story])
    unit[:intact_roof] = create_if_not_exists(IntactRoof, :intact_roof, unit[:intact_roof])
    unit[:room_type_id] = unit[:salmon_type_code] != "n/a" ? unit[:salmon_type_code].to_i : nil
    unit[:type_description] = create_if_not_exists(TypeDescription, :type_description, unit[:type_description])
    unit[:inferred_function] = create_if_not_exists(InferredFunction, :inferred_function, unit[:inferred_function])
    unit[:salmon_sector] = create_if_not_exists(SalmonSector, :salmon_sector, unit[:salmon_sector])
    unit[:irregular_shape] = create_if_not_exists(IrregularShape, :irregular_shape, unit[:irregular_shape])

    u = select_or_create_unit unit[:unit_no], "Units", false
    u.update(unit)
  end
end

##########
# Strata #
##########
def seed_strata files
  s = Roo::Excel.new(files[:strata])

  puts "\n\n\nCreating Strata Types\n"

  strata_type_columns = {
    # Order as seen in spreadsheet
    code: "CODE",
    strat_type: "STRATTYPE"
  }

  s.sheet('strat descp').each(strata_type_columns) do |row|
    # Skip header row
    next if row[:code] == "CODE"

    strata_type = convert_empty_hash_values_to_none(row)

    next if StratType.where(code: strata_type[:code]).size > 0

    # Output and save
    puts "#{strata_type[:code]} => #{strata_type[:strat_type]}"
    StratType.create(strata_type)
  end


  puts "\n\n\nCreating Strata\n"

  strata_columns = {
    # Order as seen in spreadsheet
    unit: "ROOM",
    strat_all: "STRAT-ALL",
    strat_alpha: "STRAT-ALPHA",
    stratum_one: "STRATUM 1",
    stratum_two: "STRATUM 2",
    strat_occupation: "OCCUPATION",
    comments: "COMMENTS"
  }

  last_unit = ""
  s.sheet('data').each(strata_columns) do |row|
    # Skip header row
    next if row[:unit] == "ROOM"

    stratum = convert_empty_hash_values_to_none(row)

    # Output context for creation
    puts "\nUnit #{stratum[:unit]}:" if stratum[:unit] != last_unit
    last_unit = stratum[:unit]

    # Handle foreign key columns
    # TODO same note here as above, can there be more than one with unit_no?
    if Unit.where(:unit_no => stratum[:unit]).size < 1
      report "Unit", stratum[:unit], "Stratum #{stratum[:strat_all]}"
      stratum[:unit] = Unit.create(:unit_no => stratum[:unit])
    else
      stratum[:unit] = Unit.where(:unit_no => stratum[:unit]).first
    end

    stratum[:strat_occupation] = create_if_not_exists(StratOccupation, :occupation, stratum[:strat_occupation])
    stratum[:strat_type] = StratType.where(code: stratum[:strat_alpha]).first

    # Output and save
    puts stratum[:strat_all]
    Stratum.create(stratum)
  end
end

############
# Features #
############
def seed_features files
  s = Roo::Excel.new(files[:features])

  puts "\n\n\nCreating Features\n"

  feature_columns = {
    unit_no: "Room",
    feature_no: "Feature No.",
    strat: "Strat",
    floor_association: "Floor Association",
    feature_form: "Feature Form",
    other_associated_features: "Other Associated Features",
    grid: "Grid",
    depth_m_b_d: "Depth (MBD)",
    feature_occupation: "Occupation",
    feature_type: "Feature Type",
    feature_count: "Feature Count",
    feature_group: "Feature Group",
    residential_feature: "Residential Feature",
    location_in_room: "Location in Room",
    t_shaped_door: "T-Shaped Door",
    door_between_multiple_room: "Door between Multiple Rooms",
    doorway_sealed: "Doorway Sealed",
    length: "Length",
    width: "Width",
    depth_height: "Depth/Height",
    comments: "Comments"
  }

  last_unit = ""
  s.sheet('Data').each(feature_columns) do |row|
    # Skip header row
    next if row[:unit_no] == "Room"

    feature = convert_empty_hash_values_to_none(row)

    # Output context for creation
    puts "\nUnit #{feature[:unit_no]}:" if feature[:unit_no] != last_unit
    last_unit = feature[:unit_no]

    # Handle foreign key columns

    unit = find_or_create_and_log("Feature #{feature[:feature_no]}", Unit, unit_no: feature[:unit_no])

    # Process each stratum in Strat column
    feature[:strata] = []
    strats = feature[:strat].split(/[;,]/).map{ |strat| strat.strip }
    strats.uniq!
    strats.each do |strat|
      feature[:strata] << find_or_create_and_log("Feature #{feature[:feature_no]}", Stratum, strat_all: strat, unit_id: unit.id)
    end

    feature[:feature_occupation] = create_if_not_exists(FeatureOccupation, :occupation, feature[:feature_occupation])
    feature[:feature_type] = create_if_not_exists(FeatureType, :feature_type, feature[:feature_type])
    feature[:feature_group] = create_if_not_exists(FeatureGroup, :feature_group, feature[:feature_group])
    feature[:residential_feature] = create_if_not_exists(ResidentialFeature, :residential_feature, feature[:residential_feature])
    feature[:t_shaped_door] = create_if_not_exists(TShapedDoor, :t_shaped_door, feature[:t_shaped_door])
    feature[:door_between_multiple_room] = create_if_not_exists(DoorBetweenMultipleRoom, :door_between_multiple_rooms, feature[:door_between_multiple_room])
    feature[:doorway_sealed] = create_if_not_exists(DoorwaySealed, :doorway_sealed, feature[:doorway_sealed])

    # Output and save
    puts feature[:feature_no]
    Feature.create(feature)
  end
end

####################
# INVENTORY TABLES #
####################

##################
# Bone Inventory #
##################
def seed_bone_inventory files
  puts "Loading Bone Inventory ..."

  s = Roo::Excelx.new(files[:bone_inventory])

  s.sheet('Sheet1').each do |entry|
    row = convert_empty_to_none(entry)

    if row[0] != 'SITE'
      bone_inventory = {}
      bone_inventory[:site] = row[0]
      bone_inventory[:box] = row[1]
      bone_inventory[:fs] = row[2]
      bone_inventory[:bone_inventory_count] = row[3]
      bone_inventory[:gridew] = row[6]
      bone_inventory[:gridns] = row[7]
      bone_inventory[:quad] = row[8]
      bone_inventory[:exactprov] = row[9]
      bone_inventory[:depthbeg] = row[10]
      bone_inventory[:depthend] = row[11]
      bone_inventory[:stratalpha] = row[12]
      bone_inventory[:strat_one] = row[13]
      bone_inventory[:strat_two] = row[14]
      bone_inventory[:othstrats] = row[15]
      bone_inventory[:field_date] = row[16]
      bone_inventory[:excavator] = row[17]
      bone_inventory[:art_type] = row[18]
      bone_inventory[:sano] = row[19]
      bone_inventory[:recordkey] = row[20]
      bone_inventory[:comments] = row[22]
      bone_inventory[:entby] = row[23]
      bone_inventory[:location] = row[24]

      unit = select_or_create_unit(row[4], 'bone_inventories')
      # bone_inventory[:room] = unit.unit_no

      bone_inventory_row = BoneInventory.create(bone_inventory)
      associate_strata_features(unit, row[5], row[21], bone_inventory_row, "bone_inventory")
    end
  end
end

#####################
# Ceramic Inventory #
#####################
def seed_ceramic_inventory files
  puts "Loading Ceramic Inventory ..."

  s = Roo::Excelx.new(files[:ceramic_inventory])

  s.sheet('Sheet1').each do |entry|
    row = convert_empty_to_none(entry)

    if row[0] != 'SITE'
      ceramic_inventory = {}
      ceramic_inventory[:site] = row[0]
      ceramic_inventory[:box] = row[1]
      ceramic_inventory[:fs] = row[2]
      ceramic_inventory[:ceramic_inventory_count] = row[3]
      ceramic_inventory[:gridew] = row[6]
      ceramic_inventory[:gridns] = row[7]
      ceramic_inventory[:quad] = row[8]
      ceramic_inventory[:exactprov] = row[9]
      ceramic_inventory[:depthbeg] = row[10]
      ceramic_inventory[:depthend] = row[11]
      ceramic_inventory[:stratalpha] = row[12]
      ceramic_inventory[:strat_one] = row[13]
      ceramic_inventory[:strat_two] = row[14]
      ceramic_inventory[:othstrats] = row[15]
      ceramic_inventory[:field_date] = row[16]
      ceramic_inventory[:excavator] = row[17]
      ceramic_inventory[:art_type] = row[18]
      ceramic_inventory[:sano] = row[19]
      ceramic_inventory[:recordkey] = row[20]
      ceramic_inventory[:comments] = row[22]
      ceramic_inventory[:entby] = row[23]
      ceramic_inventory[:location] = row[24]

      unit = select_or_create_unit(row[4], 'ceramic_inventories')
      # ceramic_inventory[:room] = unit.unit_no

      ceramic_inventory_row = CeramicInventory.create(ceramic_inventory)
      associate_strata_features(unit, row[5], row[21], ceramic_inventory_row, "ceramic_inventory")
    end
  end
end

######################
# Lithic Inventories #
######################
def seed_lithic_inventories files
  puts "Loading Lithic Inventory ..."

  s = Roo::Excelx.new(files[:lithic_inventory])

  s.sheet('Sheet1').each do |entry|
    row = convert_empty_to_none(entry)

    if row[0] != 'SITE'
      lithic = {}
      lithic[:site] = row[0]
      lithic[:box] = row[1]
      lithic[:fs] = row[2]
      lithic[:lithic_inventory_count] = row[3]
      lithic[:gridew] = row[6]
      lithic[:gridns] = row[7]
      lithic[:quad] = row[8]
      lithic[:exactprov] = row[9]
      lithic[:depthbeg] = row[10]
      lithic[:depthend] = row[11]
      lithic[:stratalpha] = row[12]
      lithic[:strat_one] = row[13]
      lithic[:strat_two] = row[14]
      lithic[:othstrats] = row[15]
      lithic[:field_date] = row[16]
      lithic[:excavator] = row[17]
      lithic[:art_type] = row[18]
      lithic[:sano] = row[19]
      lithic[:recordkey] = row[20]
      lithic[:comments] = row[22]
      lithic[:entby] = row[23]
      lithic[:location] = row[24]

      unit = select_or_create_unit(row[4], 'lithic_inventories')
      # lithic[:room] = unit.unit_no

      lithic_row = LithicInventory.create(lithic)
      associate_strata_features(unit, row[5], row[21], lithic_row, "lithic_inventory")
    end
  end
end

###################
# ANALYSIS TABLES #
###################

##############
# Bone Tools #
##############
def seed_bone_tools files
  s = Roo::Excelx.new(files[:bonetools])

  puts "\n\n\nCreating Bone Tools\n"

  bonetools_columns = {
    room: "Room",
    strat: "Strata",
    field_specimen_no: "Field Specimen No",
    depth: "Depth (meters below datum)",
    bone_tool_occupation: "Occupation",
    grid: "Grid",
    tool_type_code: "Tool Type Code",
    tool_type: "Tool Type",
    species_code: "Species Code",
    comments: "Comments"
  }

  last_room = ""
  s.sheet('data').each(bonetools_columns) do |row|
    # Skip header row
    next if row[:room] == "Room"

    bonetool = convert_empty_hash_values_to_none(row)

    # Output context for creation
    puts "\nRoom #{bonetool[:room]}:" if bonetool[:room] != last_room
    last_room = bonetool[:room]

    # Handle foreign keys
    unit = select_or_create_unit(bonetool[:room], "Bone Tools")

    bonetool[:bone_tool_occupation] = create_if_not_exists(BoneToolOccupation, :occupation, bonetool[:bone_tool_occupation])

    bonetool[:strata] = []
    strats = bonetool[:strat].split(/[;,]/).map{ |strat| strat.strip }
    strats.uniq!
    strats.each do |strat|
      bonetool[:strata] << find_or_create_and_log("Bone Tool #{bonetool[:field_specimen_no]}", Stratum, strat_all: strat, unit_id: unit.id)
    end

    # Output and save
    puts bonetool[:field_specimen_no]
    BoneTool.create(bonetool)
  end
end

#############
# Eggshells #
#############
def seed_eggshells files
  s = Roo::Excel.new(files[:eggshells])

  puts "\n\n\nCreating Eggshells\n"

  columns = {
    room: "Room",
    strat: "Strata",
    salmon_museum_id_no: "Salmon Museum ID No.",
    record_field_key_no: "Record (Field) Key No.",
    grid: "Grid",
    quad: "Quad",
    depth: "Depth",
    feature_no: "Feature No.",
    storage_bin: "Storage Bin",
    museum_date: "Museum Date",
    field_date: "Field Date",
    eggshell_affiliation: "Affiliation",
    eggshell_item: "Item"
  }

  last_room = ""
  s.sheet('eggshell').each(columns) do |row|
    # Skip header row
    next if row[:room] == "Room"

    eggshell = convert_empty_hash_values_to_none(row)

    # Output context for creation
    puts "\nRoom #{eggshell[:room]}:" if eggshell[:room] != last_room
    last_room = eggshell[:room]

    # Handle foreign keys
    unit = select_or_create_unit(eggshell[:room], 'eggshells')

    eggshell[:features] = []
    associate_strata_features(unit, eggshell[:strat], eggshell[:feature_no], eggshell, "Eggshells")

    eggshell[:eggshell_affiliation] = (eggshell[:eggshell_affiliation]) ? create_if_not_exists(EggshellAffiliation, :affiliation, eggshell[:eggshell_affiliation]) : nil

    eggshell[:eggshell_item] = (eggshell[:eggshell_item]) ? create_if_not_exists(EggshellItem, :item, eggshell[:eggshell_item]) : nil

    # Output and save
    puts eggshell[:salmon_museum_id_no]
    Eggshell.create(eggshell)
  end
end

#############
# Ornaments #
#############
def seed_ornaments files
  s = Roo::Excelx.new(files[:ornaments])

  puts "\n\n\nCreating Ornaments\n"

  columns = {
    museum_specimen_no: "Museum Specimen No.",
    analysis_lab_no: "Analysis Lab No.",
    room: "Room",
    strat: "Strata",
    grid: "Grid",
    quad: "Quad",
    depth: "Depth       (m below datum)",
    field_date: "Field Date",
    ornament_period: "PERIOD",
    feature: "Feature or Selected Artifact (SA) No.",
    analyst: "Analyst",
    analyzed: "Analyzed",
    photographer: "Photographer",
    count: "Count",
    item: "Item"
  }

  last_room = ""
  s.sheet('data').each(columns) do |row|
    next if row[:room] == "Room"

    ornament = convert_empty_hash_values_to_none(row)

    # Output context for creation
    puts "\nRoom #{ornament[:room]}:" if ornament[:room] != last_room
    last_room = ornament[:room]

    # Handle foreign keys
    unit = select_or_create_unit(ornament[:room], "Ornaments")

    feature_no = get_feature_number(ornament[:feature], "Ornaments")
    ornament[:feature] = find_or_create_and_log("Ornament #{ornament[:museum_specimen_no]}", Feature, feature_no: feature_no, unit_no: ornament[:room])

    # TODO Review handling of CSV strat value
    # Process each stratum in Strat column
    strats = ornament[:strat].split(/[;,]/).map{ |strat| strat.strip }
    strats.uniq!
    strats.each do |strat|
      stratum = find_or_create_and_log("Ornament #{ornament[:museum_specimen_no]}", Stratum, strat_all: strat, unit_id: unit.id)

      # Associate strata through feature
      ornament[:feature].strata << stratum
    end

    ornament[:ornament_period] = create_if_not_exists(OrnamentPeriod, :period, ornament[:ornament_period])

    # Output and save
    puts ornament[:museum_specimen_no]
    Ornament.create(ornament)
  end
end

###############
# Perishables #
###############
# NOTE:  Perishables may belong to more than one unit
def seed_perishables files
  puts "Loading Perishables..."

  s = Roo::Excel.new(files[:perishables])

  s.sheet('all').each do |entry|
    # empty fields should say "none" to standardize
    row = convert_empty_to_none(entry)

    if row[0] != 'FS Number'
      perish = {}
      perish[:artifact_structure] = row[12]
      perish[:artifact_type] = row[10]
      perish[:comments] = row[13]
      perish[:depth] = row[6]
      # TODO not sure what column to use for this
      perish[:exhibit_location] = row[16]
      perish[:field_date] = row[19]
      perish[:fs_number] = row[0]
      perish[:grid] = row[4]
      perish[:museum_lab_no] = row[18]
      perish[:original_analysis] = row[20]
      perish[:other_comments] = row[14]
      perish[:perishable_count] = row[11]
      perish[:quad] = row[5]
      perish[:record_key_no] = row[17]
      perish[:room] = row[2]
      perish[:sa_no] = row[9]
      perish[:salmon_museum_number] = row[1]
      perish[:storage_location] = row[15]
      perish[:strat] = row[3]

      # period
      perish[:perishable_period_id] = create_if_not_exists(PerishablePeriod, :period, row[8]).id

      perish_row = Perishable.create(perish)

      units = row[2].split(/[,;]/).map { |u| u.strip }
      units.each do |unit_str|
        unit = select_or_create_unit(unit_str, "perishables")
        associate_strata_features(unit, row[3], row[7], perish_row, "perishables")
      end
    end
  end
end

####################
# Select Artifacts #
####################
def seed_select_artifacts files
  puts "Loading Select Artifacts..."

  s = Roo::Excel.new(files[:select_artifacts])

  s.sheet('main data').each do |entry|
    row = convert_empty_to_none(entry)

    if row[0] != 'Room'
      sa = {}
      sa[:artifact_count] = row[10]
      sa[:artifact_no] = row[1]
      # Note: The below could be parsed into specific features
      # at which point the select_artifacts_strata table should
      # be removed and a join set up with features instead
      sa[:associated_feature_artifacts] = row[5]
      sa[:comments] = row[12]
      sa[:depth] = row[7]
      sa[:floor_association] = row[3]
      sa[:grid] = row[6]
      sa[:location_in_room] = row[11]
      sa[:select_artifact_occupation_id] = create_if_not_exists(SelectArtifactOccupation, :occupation, row[8]).id
      sa[:select_artifact_type] = row[9]
      sa[:sa_form] = row[4]
      # Note: Select Artifacts have an actual relationship with strata
      # but I'm copying the string from the spreadsheet since there
      # is a specific database field that seems to be for it
      sa[:strat] = row[2]

      unit = select_or_create_unit(row[0], "select artifacts")
      sa[:room] = unit.unit_no

      select_artifact = SelectArtifact.create(sa)

      sa_strata = row[2].split(/[,;]/).map{ |stratum| stratum.strip }
      sa_strata.each do |sa_str|
        stratum = Stratum.where(strat_all: sa_str, unit_id: unit.id).first
        if stratum.nil?
          report "stratum", "#{unit.id}:#{sa_str}", "select artifact #{select_artifact.id}"
          stratum = Stratum.create(
            strat_all: sa_str,
            unit: unit,
            comments: 'imported from select artifacts spreadsheet'
          )
        end
        select_artifact.strata << stratum unless select_artifact.strata.include?(stratum)
      end
    end
  end
end

#########
# Soils #
#########
def seed_soils files
  puts "Loading Soils..."

  s = Roo::Excelx.new(files[:soils])

  columns = {
    # Ordered as seen in spreadsheet
    # Comment columns not used or saved in database
    site: "SITE",
    room: "ROOM",
    strat: "STRATUM",
    feature_key: "FEATURE",
    fs: "FS",
    box: "BOX",
    period: "PERIOD",
    soil_count: "COUNT",
    gridew: "GRIDEW",
    gridns: "GRIDNS",
    quad: "QUAD",
    exactprov: "EXACTPROV",
    depthbeg: "DEPTHBEG",
    depthend: "DEPTHEND",
    otherstrat: "OTHSTRATS",
    date: "DATE",
    excavator: "EXCAVATOR",
    arttype: "ARTTYPE",
    sample_no: "SAMPLE NO",
    comments: "COMMENTS",
    data_entry: "DATA ENTRY",
    location: "LOCATION",
  }

  s.sheet('Sheet1').each(columns) do |row_hash|
    soil = convert_empty_hash_values_to_none(row_hash)

    # Skip header row
    next if soil[:site] == "SITE"

    soil[:art_type_id] = create_if_not_exists(ArtType, :art_type, soil[:arttype]).id

    unit = select_or_create_unit(:room, 'soils')
    soil[:room] = unit.unit_no

    # Delete columns used but not saved in database
    soil.delete :arttype

    soil_record = Soil.create(soil)
    associate_strata_features(unit, soil[:room], soil[:strat], soil_record, "soil")
  end
end

##########
# Images #
##########
def seed_images files
  puts "Loading Images..."

  s = Roo::Excelx.new(files[:images])

  # NOTE:  I suspect that some of the single units are actually
  # ranges, so this whole thing will need to be redone so that
  # a given feature is attached to multiple strata attached to
  # multiple units (great sadness)

  s.sheet('data').each do |entry|
    row = convert_empty_to_none(entry)

    if row[0] != 'Site'
      record = {}
      record[:asso_features] = row[16]
      record[:comments] = row[24]
      record[:data_entry] = row[26]
      record[:date] = row[14]
      record[:dep_beg] = row[11]
      record[:dep_end] = row[12]
      record[:gride] = row[8]
      record[:gridn] = row[9]
      record[:image_no] = row[3]
      record[:image_type] = row[5]
      record[:notes] = row[28]
      record[:other_no] = row[18]
      record[:room] = row[1]
      record[:signi_art_no] = row[17]
      record[:site] = row[0]
      record[:storage_location] = row[25]
      record[:strat] = row[2]

      image = Image.create(record)

      # create / select and assign related image tables
      belongs_to = {
        ImageAssocnoeg => row[6],
        ImageBox => row[7],
        ImageCreator => row[15],
        ImageFormat => row[4],
        ImageHumanRemain => row[19],
        ImageOrientation => row[10],
        ImageQuality => row[27]
      }
      belongs_to.each do |table, data|
        record = create_if_not_exists(table, "name", data)
        relation = table.to_s.underscore
        # equivalent to `image.image_box = 'P1281'`
        image.send("#{relation}=", record)
      end

      image.save

      [row[21], row[22], row[23]].each do |subj|
        if subj != "none"
          subject = create_if_not_exists(ImageSubject, "subject", subj)
          image.image_subjects << subject
        end
      end

      # TODO remove this once the spreadsheet is revised with correct unit assignments
      if row[1].to_s.include?("-")
        report "unit", row[1], "images (actually NOT added because of the hyphen)"
      else
        unit = select_or_create_unit(row[1], "images")
        associate_strata_features(unit, row[2], row[16], image, "images")
      end
    end
  end
end

###################
# Seeding Control #
###################
# Primary Tables
seed_units(files) if Unit.all.size < 1
seed_strata(files) if Stratum.all.size < 1
seed_features(files) if Feature.all.size < 1

# Inventory Tables
seed_bone_inventory(files) if BoneInventory.all.size < 1
seed_ceramic_inventory(files) if CeramicInventory.all.size < 1
seed_lithic_inventories(files) if LithicInventory.all.size < 1

# Analysis Tables
seed_bone_tools(files) if BoneTool.all.size < 1
seed_eggshells(files) if Eggshell.all.size < 1
seed_ornaments(files) if Ornament.all.size < 1
seed_perishables(files) if Perishable.all.size < 1
seed_select_artifacts(files) if SelectArtifact.all.size < 1
seed_soils(files) if Soil.all.size < 1

# Images
seed_images(files) if Image.all.size < 1

# Logging
File.open("reports/please_check_for_accuracy.txt", "w") do |file|
  file.write("Please review the following and verify that units, strata, etc, were added correctly\n")
  @handcheck.each do |added|
    file.write("\n#{added[:category]} #{added[:value]} created from #{added[:source]}")
  end
end
