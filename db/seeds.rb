# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

################
# Spreadsheets #
################

files = {
  # Primary Tables
  units: 'xls/UnitSummary2017-CCH.xlsx',
  strata: 'xls/Strata2017.xls',
  features: 'xls/Features2017.xls',

  # Inventory Tables
  bone_inventory: 'xls/Bone Inventory PARTIAL 11 rows.xlsx',
  ceramic_inventory: 'xls/Ceramic Inventory 2017.xlsx',
  lithic_inventory: 'xls/LithicInventory2017.xlsx',

  # Analysis Tables
  bonetools: 'xls/BoneToolDB.xlsx',
  eggshells: 'xls/Eggshell2017.xls',
  ornaments: 'xls/OrnamentDB2017.xlsx',
  perishables: 'xls/Perishables2017.xls',
  select_artifacts: 'xls/SelectArtifacts2017.xls',
  soils: 'xls/SoilMaster2017.xlsx',

  # Images
  images: 'xls/old/Images.xlsx'
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
      zone = Zone.create(name: "Other")
      room = Unit.create(:unit_no => "Other", :zone => zone)
      puts "Creating \"Other\" for #{unit}"
    else
      room = Unit.where(:unit_no => 'Other').first
#      puts "Using \"Other\" for #{unit}"
    end
  end
  return room
end

def select_or_create_zone_from_unit unit_str, spreadsheet, log=true
  num = unit_str.sub(/^0*/, "").sub(/[A-Z\/]*$/, "")
  if Zone.where(name: num).size < 1
    puts "\nZone #{num}:"
    report "Zone", num, spreadsheet if log
    return Zone.create(name: num)
  else
    return Zone.where(name: num).first
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
    unit[:excavation_status] = create_if_not_exists(ExcavationStatus, :name, unit[:excavation_status])
    unit[:unit_occupation] = create_if_not_exists(UnitOccupation, :name, unit[:unit_occupation])
    unit[:unit_class] = create_if_not_exists(UnitClass, :name, unit[:unit_class])
    unit[:story] = create_if_not_exists(Story, :name, unit[:story])
    unit[:intact_roof] = create_if_not_exists(IntactRoof, :name, unit[:intact_roof])
    unit[:room_type_id] = unit[:salmon_type_code] != "n/a" ? unit[:salmon_type_code].to_i : nil
    unit[:type_description] = create_if_not_exists(TypeDescription, :name, unit[:type_description])
    unit[:inferred_function] = create_if_not_exists(InferredFunction, :name, unit[:inferred_function])
    unit[:salmon_sector] = create_if_not_exists(SalmonSector, :name, unit[:salmon_sector])
    unit[:irregular_shape] = create_if_not_exists(IrregularShape, :name, unit[:irregular_shape])

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
    name: "STRATTYPE"
  }

  s.sheet('strat descp').each(strata_type_columns) do |row|
    # Skip header row
    next if row[:code] == "CODE"

    strata_type = convert_empty_hash_values_to_none(row)

    next if StratType.where(code: strata_type[:code]).size > 0

    # Output and save
    puts "#{strata_type[:code]} => #{strata_type[:name]}"
    StratType.create(strata_type)
  end


  puts "\n\n\nCreating Strata\n"

  strata_columns = {
    # Order as seen in spreadsheet
    unit: "ROOM",
    strat_all: "STRATUM",
    strat_alpha: "STRATUM-ALPHA",
    strat_one: "STRATUM 1",
    strat_two: "STRATUM 2",
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

    stratum[:strat_occupation] = create_if_not_exists(StratOccupation, :name, stratum[:strat_occupation])
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
    strat: "Stratum",
    strat_other: "Other Strata",
    floor_association: "Floor Association",
    feature_form: "Feature Form",
    other_associated_features: "Other Associated Features",
    grid: "Grid",
    depth_mbd: "Depth (MBD)",
    feature_occupation: "Occupation",
    feature_type: "Feature Type",
    count: "Feature Count",
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

    feature[:feature_occupation] = create_if_not_exists(FeatureOccupation, :name, feature[:feature_occupation])
    feature[:feature_type] = create_if_not_exists(FeatureType, :name, feature[:feature_type])
    feature[:feature_group] = create_if_not_exists(FeatureGroup, :name, feature[:feature_group])
    feature[:residential_feature] = create_if_not_exists(ResidentialFeature, :name, feature[:residential_feature])
    feature[:t_shaped_door] = create_if_not_exists(TShapedDoor, :name, feature[:t_shaped_door])
    feature[:door_between_multiple_room] = create_if_not_exists(DoorBetweenMultipleRoom, :name, feature[:door_between_multiple_room])
    feature[:doorway_sealed] = create_if_not_exists(DoorwaySealed, :name, feature[:doorway_sealed])

    # TODO Add strat_other column
    feature.delete :strat_other

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
  s = Roo::Excelx.new(files[:bone_inventory])

  puts "\n\n\nCreating Bone Inventories\n"

  columns = {
    site: "SITE",
    box: "BOX",
    fs_no: "FS",
    count: "COUNT",
    room: "ROOM",
    stratum: "STRATUM",
    strat_other: "OTHER STRATA",
    feature: "FEATURE NO",
    sa_no: "SA NO",
    grid_ew: "GRID EW",
    grid_ns: "GRID NS",
    quad: "QUAD",
    exact_prov: "EXACTPROV",
    depth_begin: "DEPTHBEG",
    depth_end: "DEPTHEND",
    field_date: "DATE",
    excavator: "EXCAVATOR",
    art_type: "ARTTYPE",
    # Empty column
    record_field_key_no: "RECORDKEY",
    comments: "COMMENTS",
    entered_by: "ENTBY",
    location: "LOCATION"
  }

  last_room = ""
  s.sheet('Sheet1').each(columns) do |row|
    # Skip header row
    next if row[:room] == "ROOM"

    bone_inv = convert_empty_hash_values_to_none(row)

    # Output context for creation
#    puts "\nRoom #{bone_inv[:room]}:" if bone_inv[:room] != last_room
    last_room = bone_inv[:room]

    # Handle foreign keys
    unit = select_or_create_unit(bone_inv[:room], 'Bone Inventories')

    bone_inv[:features] = []
    associate_strata_features(unit, bone_inv[:stratum], bone_inv[:feature], bone_inv, "Bone Inventory")

    # TODO Add room, stratum, & feature columns to BoneInventory model
    bone_inv.delete :room
    bone_inv.delete :stratum
    bone_inv.delete :feature

    # TODO Remove strat_alpha, strat_one, and strat_two from schema

    # Output and create
#    puts bone_inv[:fs_no]
    BoneInventory.create(bone_inv)
  end
end

#####################
# Ceramic Inventory #
#####################
def seed_ceramic_inventory files
  s = Roo::Excelx.new(files[:ceramic_inventory])

  puts "\n\n\nCreating Ceramic Inventories\n"

  columns = {
    site: "SITE",
    box: "BOX",
    fs_no: "FS",
    count: "COUNT",
    room: "ROOM",
    stratum: "STRATUM",
    strat_other: "OTHER STRATA",
    feature: "FEATURE",
    sa_no: "SA NO",
    grid_ew: "GRID EW",
    grid_ns: "GRID NS",
    quad: "QUAD",
    exact_prov: "EXACTPROV",
    depth_begin: "DEPTHBEG",
    depth_end: "DEPTHEND",
    field_date: "FIELD DATE",
    excavator: "EXCAVATOR",
    art_type: "ARTTYPE",
    record_field_key_no: "RECORDKEY",
    comments: "COMMENTS",
    entered_by: "ENTBY",
    status: "STATUS",
    location: "LOCATION"
  }

  last_room = ""
  s.sheet('Sheet1').each(columns) do |row|
    # Skip header row
    next if row[:room] == "ROOM"

    ceramic_inv = convert_empty_hash_values_to_none(row)

    # Output context for creation
#    puts "\nRoom #{ceramic_inv[:room]}:" if ceramic_inv[:room] != last_room
    last_room = ceramic_inv[:room]

    unit = select_or_create_unit(ceramic_inv[:room], "Ceramic Inventories")

    ceramic_inv[:features] = []
    associate_strata_features(unit, ceramic_inv[:stratum], ceramic_inv[:feature], ceramic_inv, "Ceramic Inventories")

    # TODO Add room, stratum, feature, and status columns to CeramicInventory model
    ceramic_inv.delete :room
    ceramic_inv.delete :stratum
    ceramic_inv.delete :feature
    ceramic_inv.delete :status

    # TODO Remove strat_alpha, strat_one, and strat_two from schema

    # Output and save
#    puts ceramic_inv[:fs_no]
    CeramicInventory.create(ceramic_inv)
  end
end

######################
# Lithic Inventories #
######################
def seed_lithic_inventories files
  s = Roo::Excelx.new(files[:lithic_inventory])

  puts "\n\n\nCreating Lithic Inventories\n"

  columns = {
    site: "SITE",
    box: "BOX",
    fs_no: "FS No.",
    count: "COUNT",
    room: "ROOM",
    stratum: "STRATUM",
    strat_other: "OTHSTRATS",
    feature: "FEATURE",
    sa_no: "SA NO",
    grid_ew: "GRIDEW",
    grid_ns: "GRIDNS",
    quad: "QUAD",
    exact_prov: "EXACTPROV",
    depth_begin: "DEPTHBEG",
    depth_end: "DEPTHEND",
    field_date: "DATE",
    excavator: "EXCAVATOR",
    art_type: "ARTTYPE",
    record_field_key_no: "RECORDKEY",
    comments: "COMMENTS",
    entered_by: "ENTBY",
    location: "LOCATION"
  }

  last_room = ""
  s.sheet('Sheet1').each(columns) do |row|
    # Skip header row
    next if row[:room] == "ROOM"

    lithic = convert_empty_hash_values_to_none(row)

    # Output context for creation
#    puts "\nRoom #{lithic[:room]}:" if lithic[:room] != last_room
    last_room = lithic[:room]

    # Handle foreign keys
    unit = select_or_create_unit(lithic[:room], "Lithic Inventories")

    lithic[:features] = []
    associate_strata_features(unit, lithic[:stratum], lithic[:feature], lithic, "Lithic Inventories")

    # TODO Add room, stratum, and feature columns to LithicInventory model
    lithic.delete :room
    lithic.delete :stratum
    lithic.delete :feature

    # TODO Remove strat_alpha, strat_one, and strat_two from schema

    # Output and save
#    puts lithic[:fs_no]
    LithicInventory.create(lithic)
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
    unit: "Room",
    strat: "Stratum",
    strat_other: "Other Strata ",
    feature: "Feature No",
    sa_no: "Select Artifact No.",
    fs_no: "FS No",
    depth: "Depth (meters below datum)",
    bone_tool_occupation: "Occupation",
    grid: "Grid",
    tool_type_code: "Tool Type Code",
    tool_type: "Tool Type",
    species_code: "Species Code",
    comments: "Comments"
  }

  last_unit = ""
  s.sheet('data').each(bonetools_columns) do |row|
    # Skip header row
    next if row[:unit] == "Room"

    bonetool = convert_empty_hash_values_to_none(row)

    # Output context for creation
#    puts "\nUnit #{bonetool[:unit]}:" if bonetool[:unit] != last_unit
    last_unit = bonetool[:unit]

    # Handle foreign keys
    unit = select_or_create_unit(bonetool[:unit], "Bone Tools")

    bonetool[:bone_tool_occupation] = create_if_not_exists(BoneToolOccupation, :name, bonetool[:bone_tool_occupation])

    bonetool[:strata] = []
    strats = bonetool[:strat].split(/[;,]/).map{ |strat| strat.strip }
    strats.uniq!
    strats.each do |strat|
      bonetool[:strata] << find_or_create_and_log("Bone Tool #{bonetool[:fs_no]}", Stratum, strat_all: strat, unit_id: unit.id)
    end

    # TODO Add strat_other, feature, and sa_no to schema
    bonetool.delete :strat_other
    bonetool.delete :feature
    bonetool.delete :sa_no

    # Output and save
#    puts bonetool[:fs_no]
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
    unit: "ROOM",
    strat: "STRATUM",
    strat_other: "OTHER STRATA",
    feature_no: "FEATURE NO",
    grid: "GRID",
    quad: "QUAD",
    depth: "DEPTH",
    record_field_key_no: "RECORD KEY NO",
    salmon_museum_no: "SALMON MUSEUM ID NO",
    storage_bin: "STORAGE BIN",
    museum_date: "MUSEUM DATE",
    field_date: "FIELD DATE",
    eggshell_affiliation: "AFFILIATION",
    eggshell_item: "ITEM"
  }

  last_unit = ""
  s.sheet('eggshell').each(columns) do |row|
    # Skip header row
    next if row[:unit] == "Room"

    eggshell = convert_empty_hash_values_to_none(row)

    # Output context for creation
#    puts "\nUnit #{eggshell[:unit]}:" if eggshell[:unit] != last_unit
    last_unit = eggshell[:unit]

    # Handle foreign keys
    unit = select_or_create_unit(eggshell[:unit], 'eggshells')

    eggshell[:features] = []
    associate_strata_features(unit, eggshell[:strat], eggshell[:feature_no], eggshell, "Eggshells")

    eggshell[:eggshell_affiliation] = (eggshell[:eggshell_affiliation]) ? create_if_not_exists(EggshellAffiliation, :name, eggshell[:eggshell_affiliation]) : nil

    eggshell[:eggshell_item] = (eggshell[:eggshell_item]) ? create_if_not_exists(EggshellItem, :name, eggshell[:eggshell_item]) : nil

    # TODO Add strat_other to schema
    eggshell.delete :strat_other

    # Output and save
#    puts eggshell[:salmon_museum_no]
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
    salmon_museum_no: "MUSEUM SPECIMEN NO",
    analysis_lab_no: "ANALYSIS LAB NO",
    unit: "UNIT",
    strat: "STRATUM",
    strat_other: "OTHER STRATA",
    feature: "FEATURE NO",
    sa_no: "SA NO",
    grid: "GRID",
    quad: "QUAD",
    depth: "DEPTH       (m below datum)",
    field_date: "FIELD DATE",
    ornament_period: "PERIOD",
    analyst: "ANALYST",
    analyzed: "ANALYZED",
    photographer: "PHOTOGRAPHER",
    count: "COUNT",
    item: "ITEM"
  }

  last_unit = ""
  s.sheet('data').each(columns) do |row|
    next if row[:unit] == "Room"

    ornament = convert_empty_hash_values_to_none(row)

    # Output context for creation
#    puts "\nUnit #{ornament[:unit]}:" if ornament[:unit] != last_unit
    last_unit = ornament[:unit]

    # Handle foreign keys
    unit = select_or_create_unit(ornament[:unit], "Ornaments")

    feature_no = get_feature_number(ornament[:feature], "Ornaments")
    ornament[:feature] = find_or_create_and_log("Ornament #{ornament[:salmon_museum_no]}", Feature, feature_no: feature_no, unit_no: ornament[:unit])

    # TODO Review handling of CSV strat value
    # Process each stratum in Strat column
    strats = ornament[:strat].split(/[;,]/).map{ |strat| strat.strip }
    strats.uniq!
    strats.each do |strat|
      stratum = find_or_create_and_log("Ornament #{ornament[:salmon_museum_no]}", Stratum, strat_all: strat, unit_id: unit.id)

      # Associate strata through feature
      ornament[:feature].strata << stratum
    end

    ornament[:ornament_period] = create_if_not_exists(OrnamentPeriod, :name, ornament[:ornament_period])

    # TODO Add strat_other and sa_no to schema
    ornament.delete :strat_other
    ornament.delete :sa_no

    # Output and save
#    puts ornament[:salmon_museum_no]
    Ornament.create(ornament)
  end
end

###############
# Perishables #
###############
# NOTE:  Perishables may belong to more than one unit
def seed_perishables files
  s = Roo::Excel.new(files[:perishables])

  puts "\n\n\nCreating Perishables\n"

  columns = {
    fs_no: "FS Number",
    salmon_museum_number: "Salmon Museum No.",
    unit: "Room",
    strat: "Stratum",
    strat_other: "Other Strata",
    associated_feature: "Feature No",
    sa_no: "SA No",
    perishable_period: "Period",
    grid: "Grid",
    quad: "Quad",
    depth: "Depth (m below datum)",
    artifact_type: "Artifact Type",
    count: "Count",
    artifact_structure: "Artifact Structure",
    comments: "Comments",
    comments_other: "Other Comments",
    storage_location: "Storage Location",
    exhibit_location: "Exhibit Location",
    record_field_key_no: "Record Key No.",
    museum_lab_no: "Museum Lab. No",
    field_date: "Field Date",
    original_analysis: "Original Analysis "
  }

  last_unit = ""
  s.sheet('all').each(columns) do |row|
    next if row[:unit] == "Room"

    perishable = convert_empty_hash_values_to_none(row)

    # Output context for creation
#    puts "\nUnit #{perishable[:unit]}:" if perishable[:unit] != last_unit
    last_unit = perishable[:unit]

    # Handle foreign keys
    perishable[:perishable_period] = create_if_not_exists(PerishablePeriod, :name, perishable[:perishable_period])

    perishable[:features] = []
    units = perishable[:unit].split(/[,;]/).map { |u| u.strip }
    units.each do |unit|
      unit = select_or_create_unit(unit, "Perishables")
      associate_strata_features(unit, perishable[:strat], perishable[:associated_feature], perishable, "Perishables")
    end

    # TODO Add strat_other to schema
    perishable.delete :strat_other

    # Output and save
#    puts perishable[:fs_no]
    Perishable.create(perishable)
  end
end

####################
# Select Artifacts #
####################
def seed_select_artifacts files
  s = Roo::Excel.new(files[:select_artifacts])

  puts "\n\n\nCreating Select Artifacts\n"

  columns = {
    unit: "Room",
    artifact_no: "Artifact No",
    strat: "Stratum",
    strat_other: "Other Strata",
    feature: "Feature No",
    floor_association: "Floor Association",
    sa_form: "SA Form",
    associated_feature_artifacts: "Associated SA Artifacts",
    grid: "Grid",
    depth: "Depth (MBD)",
    select_artifact_occupation: "Occupation",
    select_artifact_type: "Type",
    artifact_count: "Artifact Count",
    location_in_room: "Location in Room",
    comments: "Comments"
  }

  last_unit = ""
  s.sheet('main data').each(columns) do |row|
    # Skip header row
    next if row[:unit] == "Room"

    sa = convert_empty_hash_values_to_none(row)

    # Output context for creation
#    puts "\nUnit #{sa[:unit]}:" if sa[:unit] != last_unit
    last_unit = sa[:unit]

    # Handle foreign keys
    unit = select_or_create_unit(sa[:unit], "Select Artifacts")

    # Process each stratum in Strat column
    sa[:strata] = []
    strats = sa[:strat].split(/[;,]/).map{ |strat| strat.strip }
    strats.uniq!
    strats.each do |strat|
      sa[:strata] << find_or_create_and_log("Select Artifact #{sa[:artifact_no]}", Stratum, strat_all: strat, unit_id: unit.id)
    end

    sa[:select_artifact_occupation] = create_if_not_exists(SelectArtifactOccupation, :name, sa[:select_artifact_occupation])

    # NOTE: associated_feature_artifacts considered for model associations
    # If done, the select_artifacts_strata table should be removed
    # and a join set up with features instead

    # TODO Add strat_other and feature to schema
    sa.delete :strat_other
    sa.delete :feature

    # Output and create
#    puts sa[:artifact_no]
    SelectArtifact.create(sa)
  end
end

#########
# Soils #
#########
def seed_soils files
  s = Roo::Excelx.new(files[:soils])

  puts "\n\n\nCreating Soils\n"

  columns = {
    site: "SITE",
    unit: "ROOM",
    strat: "STRATUM",
    strat_other: "OTHER STRATA",
    feature_key: "FEATURE",
    sa_no: "SA NO",
    fs_no: "FS NO",
    box: "BOX",
    count: "COUNT",
    grid_ew: "GRIDEW",
    grid_ns: "GRIDNS",
    quad: "QUAD",
    exact_prov: "EXACTPROV",
    depth_begin: "DEPTHBEG",
    depth_end: "DEPTHEND",
    date: "DATE",
    excavator: "EXCAVATOR",
    art_type: "ARTTYPE",
    sample_no: "OTHER SAMPLE NO",
    comments: "COMMENTS",
    entered_by: "DATA ENTRY",
    location: "LOCATION"
  }

  last_unit = ""
  s.sheet('Sheet1').each(columns) do |row|
    # Skip header row
    next if row[:unit] == "ROOM"

    soil = convert_empty_hash_values_to_none(row)

    # Output context for creation
#    puts "\nUnit #{soil[:unit]}:" if soil[:unit] != last_unit
    last_unit = soil[:unit]

    # Handle foreign keys
    soil[:art_type] = create_if_not_exists(ArtType, :name, soil[:art_type])

    unit = select_or_create_unit(:unit, 'soils')

    soil[:features] = []
    associate_strata_features(unit, soil[:unit], soil[:strat], soil, "Soils")

    # TODO Add sa_no to and remove period from to schema
    soil.delete :sa_no

    # Output and save
#    puts soil[:fs_no]
    soil_record = Soil.create(soil)
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
      record[:associated_features] = row[16]
      record[:comments] = row[24]
      record[:entered_by] = row[26]
      record[:date] = row[14]
      record[:depth_begin] = row[11]
      record[:depth_end] = row[12]
      record[:grid_ew] = row[8]
      record[:grid_ns] = row[9]
      record[:image_no] = row[3]
      record[:image_type] = row[5]
      record[:notes] = row[28]
      record[:other_no] = row[18]
      record[:unit] = row[1]
      record[:sa_no] = row[17]
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
          subject = create_if_not_exists(ImageSubject, :name, subj)
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
#seed_images(files) if Image.all.size < 1

# Logging
File.open("reports/please_check_for_accuracy.txt", "w") do |file|
  file.write("Please review the following and verify that units, strata, etc, were added correctly\n")
  @handcheck.each do |added|
    file.write("\n#{added[:category]} #{added[:value]} created from #{added[:source]}")
  end
end
