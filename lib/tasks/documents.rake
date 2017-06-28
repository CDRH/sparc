require "csv"
require "mini_exiftool"

DOCUMENT_PATH = "/Volumes/LaCie/DISW\ Boxes/document_jpegs"
SEEDS_FILE = "#{Rails.root}/db/seeds/documents.csv"

def additional_units(unit, filename)
  units = [unit]
  # check if there is a match for the overall unit
  # and if so, ignore it entirely while adding new ones
  case unit
  when "013P"
    units = %w{113P 213P 313P 413P 513P}
  when "032"
    units = %w{032A 032W}
  when "035"
    units = %w{035A 035W}
  when "060"
    units = %w{060A 060B}
  when "102W"
    units = %w{102A 102B 102C 102D}
  end
  # TODO in the documents 6 and 7 directory, there are many
  # files that should apply to multiple units which are being processed
  # need to get a list from Carrie / Paul of which units these files should
  # be applied to, because multiple of them are not currently units (101, 102, etc)
  return units
end

def get_specs(filepath)
  doc = MiniExiftool.new(filepath)
  image_size = doc.image_size
  resolution = doc.x_resolution
  return "Size: #{image_size}; Resolution: #{resolution} dpi"
end

def should_skip?(unit_num)
  unit_num == "SA15" || unit_num == "SA16" || unit_num == "TT02"
end

namespace :documents do
  desc "create a csv by reading through all the document jpegs"
  task create_csv: :environment do

    # csv header and container
    records = [
      [
        "units",
        "document_type",
        "format",
        "page_id",
        "scan_no",
        "image_upload",
        "scan_specifications",
        "scan_equipment",
        "scan_date",
        "scan_creator",
        "scan_creator_status",
        "rights",
        "rank"
      ]
    ]

    files  = Dir.glob("#{DOCUMENT_PATH}/**/**").reject { |f| File.directory?(f) }
    files.sort!

    # use this to assign a page value based on unit + document_type
    page_counter = 0
    prev_unit = ""
    prev_doc_type = ""

    files.each do |filepath|
      filename_no_ext = File.basename(filepath, ".*")
      unit_num, doc_type, scan_no = filename_no_ext.split("_", 4)
      # some units should not be included in the DB, per Paul's instructions
      next if should_skip?(unit_num)

      units = additional_units(unit_num, filename_no_ext)

      # skip record inventory files
      next if doc_type == "RI"

      if unit_num != prev_unit
        page_counter = 0
        prev_unit = unit_num
        prev_doc_type = doc_type
        puts "unit: #{unit_num}"
      elsif doc_type != prev_doc_type
        page_counter = 0
        prev_doc_type = doc_type
      else
        page_counter += 1
      end

      # TODO scan specifications and scan date -- what to put?
      page_id = filename_no_ext
      format = "jpeg"
      image_upload = File.basename(filepath)
      scan_specifications = get_specs(filepath)
      scan_equipment = "Canon DR-9050C and Capture Perfect Software"
      scan_date = "2015-2016"
      scan_creator = "Document Imaging of the Southwest, http://docimagingsw.com"
      scan_creator_status = "Public"
      rights = "University of Nebraska-Lincoln and the San Juan County Museum Association"

      records << [
        units,
        doc_type,
        format,
        page_id,
        scan_no,
        image_upload,
        scan_specifications,
        scan_equipment,
        scan_date,
        scan_creator,
        scan_creator_status,
        rights,
        page_counter
      ]
    end
    puts "writing to file #{SEEDS_FILE}"
    File.write(SEEDS_FILE, records.map(&:to_csv).join)

  end

end
