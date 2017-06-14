# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

################
# Spreadsheets #
################

seeds = Rails.root.join('db', 'seeds')

@files = {
  # Primary Tables
  units: 'xls/Units.xlsx',
  strata: 'xls/Strata.xls',
  features: 'xls/Features.xls',

  # Inventory Tables
  bone_inventory: 'xls/BoneInventory_partial.xlsx',
  ceramic_inventory: 'xls/CeramicInventory.xlsx',
  lithic_inventory: 'xls/LithicInventory.xlsx',
  obsidian_inventory: 'xls/ObsidianInventory.xlsx',
  pollen_inventory: 'xls/PollenInventory.xlsx',
  wood_inventory: 'xls/WoodInventory.xls',

  # Seeds
  lithic_artifact_types: "#{seeds}/lithic_artifact_types.yml",
  lithic_conditions: "#{seeds}/lithic_conditions.yml",
  lithic_material_types: "#{seeds}/lithic_material_types.yml",
  lithic_platform_types: "#{seeds}/lithic_platform_types.yml",
  lithic_terminations: "#{seeds}/lithic_terminations.yml",
  strat_groupings: "#{seeds}/strat_groupings.yml",

  # Analysis Tables
  bonetools: 'xls/BoneTools.xlsx',
  burials: 'xls/Burials.xls',
  ceramics: 'xls/CeramicAnalysis.xlsx',
  ceramic_claps: 'xls/Clap.xls',
  ceramic_vessels: 'xls/CeramicVessels_partial.xlsx',
  eggshells: 'xls/Eggshells.xls',
  lithic_debitages: 'xls/LithicDebitage.xlsx',
  lithic_tools: 'xls/LithicTools.xlsx',
  ornaments: 'xls/Ornaments.xlsx',
  perishables: 'xls/Perishables.xls',
  select_artifacts: 'xls/SelectArtifacts.xls',
  soils: 'xls/Soils.xlsx',
  tree_rings: 'xls/TreeRings.xlsx',

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

# return the id of an inventory record with a matching fs_no AND unit_no
# eventually we should not need the unit_no, but since there are duplicated
# fs_nos in the inventory spreadsheets, this attempts to narrow it down
# and then takes the FIRST one that matches
# unit is optional
def associate_analysis_with_inventory model, fs_no, unit=nil
  query = model.where(fs_no: fs_no)
  if unit
    begin
      query.joins(:units).where(units: { unit_no: unit.unit_no })
    rescue => e
      puts "COULD NOT JOIN #{model} WITH UNITS: #{e}"
      return nil
    end
  end
  return query.first
end

# given a specific unit with a list of strata and features, find or create
# all the items and create appropriate relationships
# returns the features
#   unit has many strata which have many features
#   feature is uniquely identified by unit, stratum, and feature_no
def associate_strata_features unit, aStrata, aFeatures, related_item, source, mult_feature=true
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
      stratum.features << feature if !stratum.features.include?(feature)
      if related_item
        if mult_feature
          related_item[:features] = [] if related_item[:features].blank?
          related_item[:features] << feature
        else
          related_item[:feature] = feature
        end
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

def find_or_create_occupation(occupation)
  # change any of the below keys into the value
  mapping = {
    "Chaco" => "Chacoan",
    "Chaco?" => "Chacoan?",
    "Chaco, San Juan" => "Mixed Chacoan and San Juan",
    "historic" => "Historic",
    "Mixed Chaco and San Juan" => "Mixed Chacoan and San Juan",
    "Mixed Chacoan & San Juan" => "Mixed Chacoan and San Juan",
    "Mixed" => "Mixed Chacoan and San Juan",
    "no data" => "No Data",
    "unknown" => "Unknown"
  }
  # strip the occupation before trying to match
  occupation.strip!
  name = mapping[occupation] || occupation
  occ = Occupation.where(:name => name).first
  if occ.nil?
    occ = Occupation.create(:name => name)
  end
  return occ
end

def find_or_create_and_log(source, model, **attributes)
  model.find_or_create_by(attributes) do |record|
    record.comments = "Imported from #{source}"
    report model, attributes.values.first, source
  end
end

def get_feature_number feat_str, source
  feature = nil
  if feat_str == "no data" || feat_str == "none" || feat_str == "unknown"
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

def load_yaml file
  YAML::load_file(file)
end

# TODO "none" will fail for integer column, etc
# but I'm leaving it because it would have already been failing
def prepare_cell_values entry_hash
  return entry_hash.each do |key, value|
    value = "none" if value.blank?
    if value.class == String
      entry_hash[key] = value.strip
    end
  end
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
def seed_units
  s = Roo::Excelx.new(@files[:units])

  puts "\n\n\nCreating Room Types\n"

  room_type_columns = {
    # Order as seen in spreadsheet
    id: "Type No.",
    description: "Description",
    occupation: "Period",
    location: "Location"
  }

  s.sheet('room typology').each(room_type_columns) do |row|
    # Skip header row
    next if row[:id] == "Type No."

    room_type = prepare_cell_values(row)

    room_type[:id] = room_type[:id].to_i
    next if RoomType.where(id: room_type[:id]).size > 0
    room_type[:occupation] = find_or_create_occupation(room_type[:occupation])

    puts "\n#{room_type[:id]}"
    puts "  When  : #{room_type[:occupation]}"
    puts "  Where : #{room_type[:location]}"
    puts "  Descrp: #{room_type[:description]}"
    RoomType.create(room_type)
  end


  puts "\n\n\nCreating Units\n"

  unit_columns = {
    # Order as seen in spreadsheet
    unit_no: "Unit No.",
    excavation_status: "Excavation Status",
    occupation: "Occupation",
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

    unit = prepare_cell_values(row)

    # Handle foreign key columns
    unit[:excavation_status] = create_if_not_exists(ExcavationStatus, :name, unit[:excavation_status])
    unit[:occupation] = find_or_create_occupation(unit[:occupation])
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
def seed_strata
  s = Roo::Excel.new(@files[:strata])

  puts "\n\n\nCreating Strata Types\n"

  strata_type_columns = {
    # Order as seen in spreadsheet
    code: "CODE",
    name: "STRATTYPE"
  }

  s.sheet('strat descp').each(strata_type_columns) do |row|
    # Skip header row
    next if row[:code] == "CODE"

    strata_type = prepare_cell_values(row)

    next if StratType.where(code: strata_type[:code]).size > 0

    # assign the type to a grouping
    group_name = "Other"
    case strata_type[:code]
    when "E", "F", "FC", "N"
      group_name = "Roof"
    when "C", "CT", "CU", "M"
      group_name = "Midden"
    when "H", "I", "O"
      group_name = "Floor"
    when "L"
      group_name = "Features"
    when "G"
      group_name = "Other"
    end
    strata_type[:strat_grouping] = StratGrouping.where(name: group_name).first

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
    occupation: "OCCUPATION",
    comments: "COMMENTS"
  }

  last_unit = ""
  s.sheet('data').each(strata_columns) do |row|
    # Skip header row
    next if row[:unit] == "ROOM"

    stratum = prepare_cell_values(row)

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

    stratum[:occupation] = find_or_create_occupation(stratum[:occupation])
    stratum[:strat_type] = StratType.where(code: stratum[:strat_alpha]).first

    # Output and save
    puts stratum[:strat_all]
    Stratum.create(stratum)
  end
end

############
# Features #
############
def seed_features
  s = Roo::Excel.new(@files[:features])

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
    occupation: "Occupation",
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

    feature = prepare_cell_values(row)

    # Output context for creation
    puts "\nUnit #{feature[:unit_no]}:" if feature[:unit_no] != last_unit
    last_unit = feature[:unit_no]

    # Handle foreign key columns
    # standardize feature number
    feature[:feature_no] = get_feature_number feature[:feature_no], "features"
    unit = find_or_create_and_log("Feature #{feature[:feature_no]}", Unit, unit_no: feature[:unit_no])

    # Process each stratum in Strat column
    feature[:strata] = []
    strats = feature[:strat].split(/[;,]/).map{ |strat| strat.strip }
    strats.uniq!
    strats.each do |strat|
      feature[:strata] << select_or_create_stratum(unit, strat, "Feature #{feature[:feature_no]}")
    end

    feature[:occupation] = find_or_create_occupation(feature[:occupation])
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
def seed_bone_inventory
  s = Roo::Excelx.new(@files[:bone_inventory])

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

    bone_inv = prepare_cell_values(row)

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
def seed_ceramic_inventory
  s = Roo::Excelx.new(@files[:ceramic_inventory])

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

    ceramic_inv = prepare_cell_values(row)

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
def seed_lithic_inventories
  s = Roo::Excelx.new(@files[:lithic_inventory])

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

    lithic = prepare_cell_values(row)

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

########################
# Obsidian Inventories #
########################
def seed_obsidian_inventory
  s = Roo::Excelx.new(@files[:obsidian_inventory])

  puts "\n\n\nCreating Obsidian Inventories\n"

  columns = {
    site: "SITE",
    box: "BOX",
    fs_no: "FS",
    unit: "ROOM",
    strat: "STRATUM",
    strat_other: "OTHSTRATS",
    feature_no: "FEATURE",
    lithic_id: "Lithic ID No",
    count: "COUNT",
    occupation: "PERIOD",
    material_type: "MATERIAL TYPE",
    shackley_sourcing: "Shackley Sourcing",
    obsidian_identified_source: "ID'ed Source",
    grid_ew: "GRIDEW",
    grid_ns: "GRIDNS",
    quad: "QUAD",
    exact_prov: "EXACTPROV",
    artifact_type: "ART TYPE",
    depth_begin: "DEPTHBEG",
    depth_end: "DEPTHEND",
    date: "DATE",
    excavator: "EXCAVATOR",
    record_field_key_no: "RECORDKEY",
    comments: "COMMENTS",
    entered_by: "ENTBY",
    location: "LOCATION"
  }

  last_room = ""
  s.sheet('Sheet1').each(columns) do |row|
    # Skip header row
    next if row[:site] == "SITE"

    obsidian = prepare_cell_values(row)

    # Output context for creation
    # puts "\nRoom #{obsidian[:unit]}:" if obsidian[:unit] != last_room
    last_room = obsidian[:unit]

    # Handle foreign keys
    unit = select_or_create_unit(obsidian[:unit], "Obsidian Inventories")

    associate_strata_features(unit, obsidian[:strat], obsidian[:feature_no], obsidian, "Obsidian Inventories", false)

    obsidian[:occupation] = find_or_create_occupation(obsidian[:occupation])
    obsidian[:obsidian_identified_source] = create_if_not_exists(ObsidianIdentifiedSource, :name, obsidian[:obsidian_identified_source])

    # Output and save
    # puts obsidian[:fs_no]
    ObsidianInventory.create(obsidian)
  end
end

######################
# Pollen Inventories #
######################
def seed_pollen_inventories
  s = Roo::Excelx.new(@files[:pollen_inventory])

  puts "\n\n\nCreating Pollen Inventories\n"

  columns = {
    salmon_museum_no: "Salmon Museum No",
    unit: "Room",
    strat: "Stratum",
    strat_other: "Other Strata",
    feature_no: "Feature No",
    sa_no: "SA No",
    grid: "Grid",
    quad: "Quad",
    depth: "Depth",
    box: "Storage Box",
    record_field_key_no: "Record Key No",
    other_sample_no: "Other Sample No.",
    date: "Field Date",
    analysis_completed: "Analysis Completed",
    frequency: "Frequency"
  }

  last_room = ""
  s.sheet('POLLEN').each(columns) do |row|
    # Skip header row
    next if row[:salmon_museum_no] == "Salmon Museum No"

    pollen = prepare_cell_values(row)

    # Output context for creation
    # puts "\nRoom #{pollen[:unit]}:" if pollen[:unit] != last_room
    last_room = pollen[:unit]

    # Handle foreign keys
    unit = select_or_create_unit(pollen[:unit], "Pollen Inventories")

    pollen[:features] = []
    # TODO will need to revisit after splitting strata into primary / other
    # in join table
    associate_strata_features(unit, pollen[:strat], pollen[:feature_no], pollen, "Pollen Inventories")
    pollen.delete(:feature_no)
    # Output and save
    # puts pollen[:salmon_museum_no]
    PollenInventory.create(pollen)
  end
end

######################
# Wood Inventories #
######################
def seed_wood_inventories
  s = Roo::Excel.new(@files[:wood_inventory])

  puts "\n\n\nCreating Wood Inventories\n"

  columns = {
    site: "SITE",
    unit: "ROOM",
    strat: "STRATUM",
    strat_other: "OTHER STRATA",
    feature_no: "FEATURE NO",
    sa_no: "SA NO",
    salmon_museum_no: "MUSEUM NO",
    storage_location: "STORAGE LOCATION",
    display: "DISPLAY",
    museum_date: "MUSEUM DATE",
    grid: "GRID",
    quad: "QUAD",
    depth: "DEPTH (mbd)",
    record_field_key_no: "RECORD KEY",
    field_date: "FIELD DATE",
    lab: "LAB NO",
    analysis: "ANALYSIS",
    description: "DESCRIPTION"
  }

  last_room = ""
  s.sheet('data').each(columns) do |row|
    # Skip header row
    next if row[:site] == "SITE"

    wood = prepare_cell_values(row)

    # Output context for creation
    # puts "\nRoom #{wood[:unit]}:" if wood[:unit] != last_room
    last_room = wood[:unit]

    # Handle foreign keys
    unit = select_or_create_unit(wood[:unit], "Wood Inventories")

    wood[:features] = []
    # TODO will need to revisit after splitting strata into primary / other
    # in join table
    associate_strata_features(unit, wood[:strat], wood[:feature_no], wood, "Wood Inventories")
    wood.delete(:feature_no)
    # Output and save
    # puts wood[:salmon_museum_no]
    WoodInventory.create(wood)
  end
end

#########################
# ANALYSIS VOCAB TABLES #
#########################

######################
# Lithic Tools Vocab #
######################

def seed_lithic_controlled_vocab
  if LithicArtifactType.count < 1
    puts "\n\n\nCreating Lithic Artifacts"
    lithic_artifact_types = load_yaml @files[:lithic_artifact_types]
    LithicArtifactType.create(lithic_artifact_types)
  end
  if LithicCondition.count < 1
    puts "\n\n\nCreating Lithic Conditions"
    lithic_conditions = load_yaml @files[:lithic_conditions]
    LithicCondition.create(lithic_conditions)
  end
  if LithicMaterialType.count < 1
    puts "\n\n\nCreating Lithic Materials"
    lithic_material_types = load_yaml @files[:lithic_material_types]
    LithicMaterialType.create(lithic_material_types)
  end
  if LithicPlatformType.count < 1
    puts "\n\n\nCreating Lithic Platforms"
    lithic_platform_types = load_yaml @files[:lithic_platform_types]
    LithicPlatformType.create(lithic_platform_types)
  end
  if LithicTermination.count < 1
    puts "\n\n\nCreating Lithic Terminations"
    lithic_terminations = load_yaml @files[:lithic_terminations]
    LithicTermination.create(lithic_terminations)
  end
end

def seed_strat_groupings
  puts "\n\n\nCreating Strata Groupings"
  strat_groupings = load_yaml @files[:strat_groupings]
  StratGrouping.create(strat_groupings)
end

###################
# ANALYSIS TABLES #
###################

##############
# Bone Tools #
##############
def seed_bone_tools
  s = Roo::Excelx.new(@files[:bonetools])

  puts "\n\n\nCreating Bone Tools\n"

  bonetools_columns = {
    unit: "Room",
    strat: "Stratum",
    strat_other: "Other Strata ",
    feature: "Feature No",
    sa_no: "Select Artifact No.",
    fs_no: "FS No",
    depth: "Depth (meters below datum)",
    occupation: "Occupation",
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

    bonetool = prepare_cell_values(row)

    # Output context for creation
#    puts "\nUnit #{bonetool[:unit]}:" if bonetool[:unit] != last_unit
    last_unit = bonetool[:unit]

    # Handle foreign keys
    unit = select_or_create_unit(bonetool[:unit], "Bone Tools")

    bonetool[:occupation] = find_or_create_occupation(bonetool[:occupation])
    bonetool[:bone_inventory] = associate_analysis_with_inventory(BoneInventory, bonetool[:fs_no], unit)

    bonetool[:strata] = []
    strats = bonetool[:strat].split(/[;,]/).map{ |strat| strat.strip }
    strats.uniq!
    strats.each do |strat|
      bonetool[:strata] << select_or_create_stratum(unit, strat, "Bone Tool: #{bonetool[:fs_no]}")
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
# Burials #
#############
def seed_burials
  s = Roo::Excel.new(@files[:burials])
  puts "\n\n\nCreating Burials\n"

  columns = {
    unit: "Room",
    strat: "Stratum",
    feature_no: "Feature No",
    new_burial_no: "New Burial No.",
    occupation: "Occupation",
    age: "Age (years)",
    burial_sex: "Sex",
    grid_ew: "Easting",
    grid_ns: "Northing",
    quad: "Quad",
    depth_begin: "DepthBeg",
    depth_end: "DeptEnd",
    date: "Date",
    excavator: "Excavator",
    record_field_key_no: "RecKey",
    associated_artifacts: "AssocArt",
    description: "Description"
  }

  last_unit = ""
  s.sheet('data').each(columns) do |row|
    # Skip header row
    next if row[:unit] == "Room"

    burial = prepare_cell_values(row)

    # Output context for creation
    # puts "\nUnit #{burial[:unit]}:" if burial[:unit] != last_unit
    last_unit = burial[:unit]

    # Handle foreign keys
    unit = select_or_create_unit(burial[:unit], "burials")
    # Note: burial may only have one feature
    associate_strata_features(unit, burial[:strat], burial[:feature_no], burial, "Burial", false)

    burial[:occupation] = find_or_create_occupation(burial[:occupation])
    burial[:burial_sex] = create_if_not_exists(BurialSex, :name, burial[:burial_sex])

    # Output and save
    # puts burial[:new_burial_no]
    Burial.create(burial)
  end
end

###################
# Ceramics (2005) #
###################

def seed_ceramics
  s = Roo::Excelx.new(@files[:ceramics])
  puts "\n\n\nCreating Ceramics\n"

  columns = {
    site: "Site No",
    fs_no: "FS No",
    lot_no: "Lot No",
    cat_no: "Cat No",
    unit: "Room No",
    strat: "Stratum",
    feature_no: "Feature No",
    sa_no: "SA No",
    pulled_sample: "Pulled sample",
    ceramic_vessel_form: "Vessel Form",
    ceramic_vessel_part: "Vessel Part",
    wall_thickness: "Wall Thickness",
    rim_radius: "Rim Radius",
    rim_arc: "Rim Arc",
    rim_eversion: "Rim Eversion",
    ceramic_exterior_pigment: "Exterior Pigment",
    ceramic_interior_pigment: "Interior Pigment",
    ceramic_exterior_surface: "Exterior Surface",
    ceramic_interior_surface: "Interior Surface",
    ceramic_vessel_appendage: "Vessel Appendage",
    residues: "Use Wear/Residue",
    modification: "Retooling/Modification",
    ceramic_temper: "Temper",
    ceramic_paste: "Paste",
    ceramic_slip: "Slip",
    ceramic_tradition: "Tradition",
    ceramic_variety: "Variety",
    ceramic_ware: "Ware",
    ceramic_specific_type: "SPECTYPT",
    ceramic_style: "Style",
    count: "Count",
    weight: "Weight",
    vessel_no: "Vessel Number",
    comments: "Comments"
  }

  last_unit = ""
  s.sheet('Sheet1').each(columns) do |row|
    # Skip header row
    next if row[:site] == "Site No"

    ceramic = prepare_cell_values(row)

    # Output context for creation
    # puts "\nUnit #{ceramic[:unit]}:" if ceramic[:unit] != last_unit
    last_unit = ceramic[:unit]

    # Handle foreign keys
    # Note: ceramic may only have one feature
    unit = select_or_create_unit(ceramic[:unit], "ceramics")
    associate_strata_features(unit, ceramic[:strat], ceramic[:feature_no], ceramic, "Ceramics", false)

    ceramic[:ceramic_inventory] = associate_analysis_with_inventory(CeramicInventory, ceramic[:fs_no], unit)

    # all those ceramic tables....
    ceramic[:ceramic_vessel_form] = create_if_not_exists(CeramicVesselForm, :name, ceramic[:ceramic_vessel_form])
    ceramic[:ceramic_vessel_part] = create_if_not_exists(CeramicVesselPart, :name, ceramic[:ceramic_vessel_part])
    ceramic[:ceramic_exterior_pigment] = create_if_not_exists(CeramicExteriorPigment, :name, ceramic[:ceramic_exterior_pigment])
    ceramic[:ceramic_interior_pigment] = create_if_not_exists(CeramicInteriorPigment, :name, ceramic[:ceramic_interior_pigment])
    ceramic[:ceramic_exterior_surface] = create_if_not_exists(CeramicExteriorSurface, :name, ceramic[:ceramic_exterior_surface])
    ceramic[:ceramic_interior_surface] = create_if_not_exists(CeramicInteriorSurface, :name, ceramic[:ceramic_interior_surface])
    ceramic[:ceramic_vessel_appendage] = create_if_not_exists(CeramicVesselAppendage, :name, ceramic[:ceramic_vessel_appendage])
    ceramic[:ceramic_temper] = create_if_not_exists(CeramicTemper, :name, ceramic[:ceramic_temper])
    ceramic[:ceramic_paste] = create_if_not_exists(CeramicPaste, :name, ceramic[:ceramic_paste])
    ceramic[:ceramic_slip] = create_if_not_exists(CeramicSlip, :name, ceramic[:ceramic_slip])
    ceramic[:ceramic_tradition] = create_if_not_exists(CeramicTradition, :name, ceramic[:ceramic_tradition])
    ceramic[:ceramic_variety] = create_if_not_exists(CeramicVariety, :name, ceramic[:ceramic_variety])
    ceramic[:ceramic_ware] = create_if_not_exists(CeramicWare, :name, ceramic[:ceramic_ware])
    ceramic[:ceramic_specific_type] = create_if_not_exists(CeramicSpecificType, :name, ceramic[:ceramic_specific_type])
    ceramic[:ceramic_style] = create_if_not_exists(CeramicStyle, :name, ceramic[:ceramic_style])

    # Output and save
    # puts ceramic[:fs_no]
    Ceramic.create(ceramic)
  end
end

################
# Ceramic CLAP #
################

def seed_ceramic_claps
  s = Roo::Excel.new(@files[:ceramic_claps])
  puts "\n\n\nCreating Ceramic CLAP\n"

  columns = {
    unit: "Room",
    strat: "Stratum",
    feature_no: "Feature No",
    ceramic_clap_type: "Ceramic Type",
    ceramic_clap_group_type: "Group Ceramic Type",
    ceramic_clap_tradition: "Tradition-Ware",
    ceramic_clap_vessel_form: "Vessel Form",
    ceramic_clap_temper: "Temper",
    record_field_key_no: "Record Key No",
    grid: "Grid",
    depth_begin: "Beg Depth",
    depth_end: "End Depth",
    field_year: "Field Year",
    sherd_lot_no: "Sherd Lot No",
    frequency: "Frequency",
    comments: "Comments"
  }

  last_unit = ""
  s.sheet('data').each(columns) do |row|
    # Skip header row
    next if row[:unit] == "Room"

    clap = prepare_cell_values(row)

    # Output context for creation
    # puts "\nUnit #{clap[:unit]}:" if clap[:unit] != last_unit
    last_unit = clap[:unit]

    # Handle foreign keys
    unit = select_or_create_unit(clap[:unit], "ceramics clap")
    associate_strata_features(unit, clap[:strat], clap[:feature_no], clap, "Ceramics CLAP")

    # all those clap tables....
    # the clap type columns are sometimes cut off, replace in those cases
    claptype = clap[:ceramic_clap_type]
    case claptype
    when "Mesa Verde B/W band design (hachure and so"
      claptype = "Mesa Verde B/W band design (hachure and solid)"
    when "Unident. Plain brown (White Mtn. Red serie"
      claptype = "Unident. Plain brown (White Mtn. Red series)"
    when "Unident. smudged brown/red (Forestdale ser"
      claptype = "Unident. smudged brown/red (Forestdale series)"
    end

    vesselform = clap[:ceramic_clap_vessel_form]
    if vesselform == "undifferentiated mug/pitcher/cyli"
      vesselform = "undifferentiated mug/pitcher/cylindrical jar"
    end

    clap[:ceramic_clap_type] = create_if_not_exists(CeramicClapType, :name, claptype)
    clap[:ceramic_clap_group_type] = create_if_not_exists(CeramicClapGroupType, :name, clap[:ceramic_clap_group_type])
    clap[:ceramic_clap_tradition] = create_if_not_exists(CeramicClapTradition, :name, clap[:ceramic_clap_tradition])
    clap[:ceramic_clap_vessel_form] = create_if_not_exists(CeramicClapVesselForm, :name, vesselform)
    clap[:ceramic_clap_temper] = create_if_not_exists(CeramicClapTemper, :name, clap[:ceramic_clap_temper])

    # Output and save
    # puts clap[:record_key_no]
    CeramicClap.create(clap)
  end
end

###################
# Ceramic Vessels #
###################

def seed_ceramic_vessels
  s = Roo::Excelx.new(@files[:ceramic_vessels])
  puts "\n\n\nCreating Ceramic Vessels\n"

  columns = {
    unit: "Room",
    strat: "Stratum",
    strat_other: "Other Strata",
    feature_no: "Feature No",
    sa_no: "SA No",
    fs_no: "FS No",
    salmon_vessel_no: "Salmon Vessel No",
    pottery_order_no: "Pottery Order No",
    record_field_key_no: "Record Key",
    vessel_percentage: "Vessel Percentage",
    lori_reed_analysis: "Lori Reed Analysis",
    ceramic_vessel_lori_reed_type: "Lori Reed Ceramic Type",
    ceramic_vessel_lori_reed_form: "Lori Reed Vessel Form",
    comments_lori_reed: "Lori Reed Comments",
    ceramic_vessel_type: "Original Vessel Type",
    ceramic_whole_vessel_form: "Original Vessel Form",
    comments_other: "Other Comments"
  }

  last_unit = ""
  s.sheet('Sheet1').each(columns) do |row|
    # Skip header row
    next if row[:unit] == "Room"

    vessel = prepare_cell_values(row)

    # Output context for creation
    # puts "\nUnit #{vessel[:unit]}:" if vessel[:unit] != last_unit
    last_unit = vessel[:unit]

    # Handle foreign keys
    unit = select_or_create_unit(vessel[:unit], "ceramics vessel")
    associate_strata_features(unit, vessel[:strat], vessel[:feature_no], vessel, "Ceramic Vessels", false)

    vessel[:ceramic_inventory] = associate_analysis_with_inventory(CeramicInventory, vessel[:fs_no], unit)

    # all those vessel tables....
    vessel[:ceramic_whole_vessel_form] = create_if_not_exists(CeramicWholeVesselForm, :name, vessel[:ceramic_whole_vessel_form])
    vessel[:ceramic_vessel_lori_reed_form] = create_if_not_exists(CeramicVesselLoriReedForm, :name, vessel[:ceramic_vessel_lori_reed_form])
    vessel[:ceramic_vessel_type] = create_if_not_exists(CeramicVesselType, :name, vessel[:ceramic_vessel_type])
    vessel[:ceramic_vessel_lori_reed_type] = create_if_not_exists(CeramicVesselLoriReedType, :name, vessel[:ceramic_vessel_lori_reed_type])

    # Output and save
    # puts vessel[:record_key_no]
    CeramicVessel.create(vessel)
  end
end

#############
# Eggshells #
#############
def seed_eggshells
  s = Roo::Excel.new(@files[:eggshells])

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
    occupation: "AFFILIATION",
    eggshell_item: "ITEM"
  }

  last_unit = ""
  s.sheet('eggshell').each(columns) do |row|
    # Skip header row
    next if row[:unit] == "ROOM"

    eggshell = prepare_cell_values(row)

    # Output context for creation
#    puts "\nUnit #{eggshell[:unit]}:" if eggshell[:unit] != last_unit
    last_unit = eggshell[:unit]

    # Handle foreign keys
    unit = select_or_create_unit(eggshell[:unit], 'eggshells')

    eggshell[:features] = []
    associate_strata_features(unit, eggshell[:strat], eggshell[:feature_no], eggshell, "Eggshells")

    eggshell[:occupation] = (eggshell[:occupation]) ? find_or_create_occupation(eggshell[:occupation]) : nil

    eggshell[:eggshell_item] = (eggshell[:eggshell_item]) ? create_if_not_exists(EggshellItem, :name, eggshell[:eggshell_item]) : nil

    # TODO Add strat_other to schema
    eggshell.delete :strat_other

    # Output and save
#    puts eggshell[:salmon_museum_no]
    Eggshell.create(eggshell)
  end
end

###################
# Lithic Debitage #
###################
def seed_lithic_debitages
  s = Roo::Excelx.new(@files[:lithic_debitages])

  puts "\n\n\nCreating Lithic Debitages\n"

  columns = {
    unit: "Room",
    fs_no: "FS #",
    artifact_no: "Artifact #",
    lithic_material_type: "Material Type",
    lithic_condition: "Condition",
    fire_altered: "Fire Altered",
    utilized: "Utilized",
    cortex_percentage: "Cortex %",
    lithic_platform_type: "Platform Type",
    lithic_termination: "Termination",
    length: "Length",
    width: "Width",
    thickness: "Thickness",
    weight: "Weight",
    comments: "Notes",
    total_flakes_in_bag: "Total Flakes in Bag"
  }

  last_unit = ""
  s.sheet('Debitage').each(columns) do |row|
    # Skip header row
    next if row[:unit] == "Room"

    deb = prepare_cell_values(row)

    # Output context for creation
#    puts "\nUnit #{deb[:unit]}:" if deb[:unit] != last_unit
    last_unit = deb[:unit]

    # Handle foreign keys
    unit = select_or_create_unit(deb[:unit], 'debitages')

    # get the features from matching inventories, else use "none"
    inventory = associate_analysis_with_inventory LithicInventory, deb[:fs_no], unit
    if inventory
      deb[:lithic_inventory] = inventory
      deb[:features] = inventory.features || []
    else
      associate_strata_features(unit, "none", "none", deb, "Lithic Debitages")
    end

    # use existing seeded lithic_deb values
    deb[:lithic_condition] = LithicCondition.where(code: deb[:lithic_condition]).first
    deb[:lithic_material_type] = LithicMaterialType.where(code: deb[:lithic_material_type]).first
    deb[:lithic_platform_type] = LithicPlatformType.where(code: deb[:lithic_platform_type]).first
    deb[:lithic_termination] = LithicTermination.where(code: deb[:lithic_termination]).first

    # Output and save
#    puts deb[:fs_no]
    LithicDebitage.create(deb)
  end
end

################
# Lithic Tools #
################
def seed_lithic_tools
  s = Roo::Excelx.new(@files[:lithic_tools])

  puts "\n\n\nCreating Lithic Tools\n"

  columns = {
    unit: "Room",
    fs_no: "FS #",
    artifact_no: "Artifact #",
    lithic_artifact_type: "Artifact Type",
    lithic_material_type: "Material Type",
    lithic_condition: "Condition",
    fire_altered: "Fire Altered",
    utilized: "Utilized",
    cortex_percentage: "Cortex %",
    lithic_platform_type: "Platform Type",
    lithic_termination: "Termination",
    cortical_flakes: "Cortical Flakes",
    non_cortical_flakes: "Non-Cortical Flakes",
    length: "Length",
    width: "Width",
    thickness: "Thickness",
    weight: "Weight",
    comments: "Notes",
    pii: "PII?"
  }

  last_unit = ""
  s.sheet('Tools').each(columns) do |row|
    # Skip header row
    next if row[:unit] == "Room"

    tool = prepare_cell_values(row)

    # Output context for creation
#    puts "\nUnit #{tool[:unit]}:" if tool[:unit] != last_unit
    last_unit = tool[:unit]

    # Handle foreign keys
    unit = select_or_create_unit(tool[:unit], 'tools')

    # get the features from matching inventories, else use "none"
    inventory = associate_analysis_with_inventory LithicInventory, tool[:fs_no], unit
    if inventory
      tool[:lithic_inventory] = inventory
      tool[:features] = inventory.features || []
    else
      associate_strata_features(unit, "none", "none", tool, "Lithic Tools")
    end

    # use existing seeded lithic_tool values
    tool[:lithic_artifact_type] = LithicArtifactType.where(code: tool[:lithic_artifact_type]).first
    tool[:lithic_condition] = LithicCondition.where(code: tool[:lithic_condition]).first
    tool[:lithic_material_type] = LithicMaterialType.where(code: tool[:lithic_material_type]).first
    tool[:lithic_platform_type] = LithicPlatformType.where(code: tool[:lithic_platform_type]).first
    tool[:lithic_termination] = LithicTermination.where(code: tool[:lithic_termination]).first

    # Output and save
#    puts tool[:fs_no]
    LithicTool.create(tool)
  end
end

#############
# Ornaments #
#############
def seed_ornaments
  s = Roo::Excelx.new(@files[:ornaments])

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
    occupation: "PERIOD",
    analyst: "ANALYST",
    analyzed: "ANALYZED",
    photographer: "PHOTOGRAPHER",
    count: "COUNT",
    item: "ITEM"
  }

  last_unit = ""
  s.sheet('data').each(columns) do |row|
    next if row[:unit] == "UNIT"

    ornament = prepare_cell_values(row)

    # Output context for creation
#    puts "\nUnit #{ornament[:unit]}:" if ornament[:unit] != last_unit
    last_unit = ornament[:unit]

    # Handle foreign keys
    unit = select_or_create_unit(ornament[:unit], "Ornaments")
    associate_strata_features(unit, ornament[:strat], ornament[:feature], ornament, "Ornament", false)

    ornament[:occupation] = find_or_create_occupation(ornament[:occupation])

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
def seed_perishables
  s = Roo::Excel.new(@files[:perishables])

  puts "\n\n\nCreating Perishables\n"

  columns = {
    fs_no: "FS Number",
    salmon_museum_number: "Salmon Museum No.",
    unit: "Room",
    strat: "Stratum",
    strat_other: "Other Strata",
    associated_feature: "Feature No",
    sa_no: "SA No",
    occupation: "Period",
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

    perishable = prepare_cell_values(row)

    # Output context for creation
#    puts "\nUnit #{perishable[:unit]}:" if perishable[:unit] != last_unit
    last_unit = perishable[:unit]

    # Handle foreign keys
    perishable[:occupation] = find_or_create_occupation(perishable[:occupation])

    perishable[:features] = []
    units = perishable[:unit].split(/[,;]/).map { |u| u.strip }.uniq
    units.each do |unit|
      unit = select_or_create_unit(unit, "Perishables")
      associate_strata_features(unit, perishable[:strat], perishable[:associated_feature], perishable, "Perishables")
    end

    # TODO Add strat_other to schema
    perishable.delete :strat_other

    # Output and save
    # puts perishable[:fs_no]
    Perishable.create(perishable)
  end
end

####################
# Select Artifacts #
####################
def seed_select_artifacts
  s = Roo::Excel.new(@files[:select_artifacts])

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
    occupation: "Occupation",
    select_artifact_type: "Type",
    artifact_count: "Artifact Count",
    location_in_room: "Location in Room",
    comments: "Comments"
  }

  last_unit = ""
  s.sheet('main data').each(columns) do |row|
    # Skip header row
    next if row[:unit] == "Room"

    sa = prepare_cell_values(row)

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
      sa[:strata] << select_or_create_stratum(unit, strat, "SA #{sa[:artifact_no]}")
    end

    sa[:occupation] = find_or_create_occupation(sa[:occupation])

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
def seed_soils
  s = Roo::Excelx.new(@files[:soils])

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
  # TODO what is column "I fo" and should it be in the DB?

  last_unit = ""
  s.sheet('Sheet1').each(columns) do |row|
    # Skip header row
    next if row[:unit] == "ROOM"

    soil = prepare_cell_values(row)

    # Output context for creation
#    puts "\nUnit #{soil[:unit]}:" if soil[:unit] != last_unit
    last_unit = soil[:unit]

    # Handle foreign keys
    soil[:art_type] = create_if_not_exists(ArtType, :name, soil[:art_type])

    unit = select_or_create_unit(soil[:unit], "Soils")

    soil[:features] = []
    associate_strata_features(unit, soil[:strat], soil[:feature_key], soil, "Soils")

    # TODO Add sa_no to schema
    soil.delete :sa_no

    # Output and save
#    puts soil[:fs_no]
    soil_record = Soil.create(soil)
  end
end

##############
# Tree Rings #
##############
def seed_tree_rings
  s = Roo::Excelx.new(@files[:tree_rings])

  puts "\n\n\nCreating Tree Rings\n"

  columns = {
    site: "Site",
    unit_no: "Room",
    strat: "Stratum",
    feature_no: "Feature No",
    occupation: "Period",
    trl_no: "TRL No.",
    year_dated: "Year Dated",
    windes_sample: "Windes Sample",
    record_field_key_no: "Record Key",
    species_tree_ring: "Species",
    inner_date: "Inner Date",
    outer_date: "Outer Date",
    symbol: "Symbol",
    cutting_date: "Cutting Date",
    comments: "Comments"
  }

  last_unit = ""
  s.sheet('Sheet1').each(columns) do |row|
    # Skip header row
    next if row[:site] == "Site"

    ring = prepare_cell_values(row)

    # Output context for creation
    # puts "\nUnit #{ring[:unit]}:" if ring[:unit] != last_unit
    last_unit = ring[:unit]

    # Handle foreign keys
    ring[:occupation] = find_or_create_occupation(ring[:occupation])
    ring[:species_tree_ring] = create_if_not_exists(SpeciesTreeRing, :name, ring[:species_tree_ring])

    unit = select_or_create_unit(ring[:unit_no], "Tree Rings")
    ring[:stratum] = select_or_create_stratum(unit, ring[:strat], "Tree Ring #{ring[:trl_no]}")

    # Output and save
    # puts ring[:fs_no]
    TreeRing.create(ring)
  end
end

##########
# Images #
##########
def seed_images
  s = Roo::Excelx.new(@files[:images])

  puts "\n\n\nCreating Images\n"

  # NOTE:  I suspect that some of the single units are actually
  # ranges, so this whole thing will need to be redone so that
  # a given feature is attached to multiple strata attached to
  # multiple units (great sadness)

  columns = {
    site: "Site",
    unit: "Room",
    strat: "Strata",
    image_no: "Photo No",
    image_format: "Image",
    image_type: "Type",
    image_assocnoeg: "Assocnoeg",
    image_box: "Box",
    grid_ew: "GridE",
    grid_ns: "GridN",
    image_orientation: "Orientation",
    depth_begin: "DepBeg",
    depth_end: "DepEnd",
    date_original: "Date",
    date: "CDRH: Date",
    image_creator: "Photographer",
    associated_features: "Feature No",
    sa_no: "Signi Art No",
    other_no: "Other No",
    image_human_remain: "CDRH: Human Remains \n(y/n)",
    image_subject1: "CDRH: Subject Category 1",
    image_subject2: "CDRH: Subject Category 2",
    image_subject3: "CDRH: Subject Category 3",
    comments: "Comments",
    storage_location: "Storage Location",
    entered_by: "Data Entry",
    image_quality: "CDRH: Image Quality Notes",
    notes: "CDRH: Notes"
  }

  last_unit = ""
  s.sheet('data').each(columns) do |row|
    # Skip header row
    next if row[:unit] == "Room"

    image = prepare_cell_values(row)

    # Output context for creation
    #puts "\nUnit #{image[:unit]}:" if image[:unit] != last_unit
    last_unit = image[:unit]

    # Handle foreign keys
    image[:image_assocnoeg] = create_if_not_exists(ImageAssocnoeg, :name, image[:image_assocnoeg])
    image[:image_box] = create_if_not_exists(ImageBox, :name, image[:image_box])
    image[:image_creator] = create_if_not_exists(ImageCreator, :name, image[:image_creator])
    image[:image_format] = create_if_not_exists(ImageFormat, :name, image[:image_format])
    image[:image_human_remain] = create_if_not_exists(ImageHumanRemain, :name, image[:image_human_remain])
    image[:image_orientation] = create_if_not_exists(ImageOrientation, :name, image[:image_orientation])
    image[:image_quality] = create_if_not_exists(ImageQuality, :name, image[:image_quality])

    image[:image_subjects] = []
    if image[:image_subject1] != "none"
      image[:image_subjects] << create_if_not_exists(ImageSubject, :name, image[:image_subject1])
    end
    if image[:image_subject2] != "none"
      image[:image_subjects] << create_if_not_exists(ImageSubject, :name, image[:image_subject2])
    end
    if image[:image_subject3] != "none"
      image[:image_subjects] << create_if_not_exists(ImageSubject, :name, image[:image_subject3])
    end

    # Remove from image hash the three strings used to create associations
    image.delete :image_subject1
    image.delete :image_subject2
    image.delete :image_subject3

    if image[:unit].to_s.include?("-")
      # TODO Remove once spreadsheet is revised with correct unit assignments
      report "unit", image[:unit], "Image with hyphen in unit NOT added"
    else
      unit = select_or_create_unit(image[:unit], "Images")

      image[:features] = []
      associate_strata_features(unit, image[:strat], image[:associated_features], image, "Images")
    end

    # TODO Add date_original to schema?
    image.delete :date_original

    # Output and save
    #puts image[:image_no]
    Image.create(image)
  end
end

###################
# Seeding Control #
###################
# Primary Tables
seed_units if Unit.count < 1
seed_strat_groupings if StratGrouping.count < 1
seed_strata if Stratum.count < 1
seed_features if Feature.count < 1

# Inventory Tables
seed_bone_inventory if BoneInventory.count < 1
seed_ceramic_inventory if CeramicInventory.count < 1
seed_lithic_inventories if LithicInventory.count < 1
seed_obsidian_inventory if ObsidianInventory.count < 1
seed_pollen_inventories if PollenInventory.count < 1
seed_wood_inventories if WoodInventory.count < 1

# Analysis Controlled Vocab Tables
seed_lithic_controlled_vocab

# Analysis Tables
seed_bone_tools if BoneTool.count < 1
seed_burials if Burial.count < 1
seed_ceramics if Ceramic.count < 1
seed_ceramic_claps if CeramicClap.count < 1
seed_ceramic_vessels if CeramicVessel.count < 1
seed_eggshells if Eggshell.count < 1
seed_lithic_debitages if LithicDebitage.count < 1
seed_lithic_tools if LithicTool.count < 1
seed_ornaments if Ornament.count < 1
seed_perishables if Perishable.count < 1
seed_select_artifacts if SelectArtifact.count < 1
seed_soils if Soil.count < 1
seed_tree_rings if TreeRing.count < 1

# Images
seed_images if Image.count < 1

# Logging
File.open("reports/please_check_for_accuracy.txt", "w") do |file|
  file.write("Please review the following and verify that units, strata, etc, were added correctly\n")
  @handcheck.each do |added|
    file.write("\n#{added[:category]} #{added[:value]} created from #{added[:source]}")
  end
end
