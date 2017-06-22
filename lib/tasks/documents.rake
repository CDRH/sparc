require "csv"
require "mini_exiftool"

DOCUMENT_PATH = "/Volumes/LaCie/DISW\ Boxes/document_jpegs"
SEEDS_FILE = "#{Rails.root}/db/seeds/documents.csv"

namespace :documents do
  desc "create a csv by reading through all the document jpegs"
  task create_csv: :environment do

    # csv header and container
    records = [
      [
        "unit",
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

      # skip record inventory files
      next if doc_type == "RI"

      if unit_num != prev_unit
        page_counter = 0
        prev_unit = unit_num
        prev_doc_type = doc_type
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
      scan_specifications = "Not sure what to put here yet"
      scan_equipment = "Canon DR-9050C and Capture Perfect Software"
      scan_date = "TODO pull metadata"
      scan_creator = "Document Imaging of the Southwest, http://docimagingsw.com"
      scan_creator_status = "Public"
      rights = "University of Nebraska-Lincoln and the San Juan County Museum Association"

      records << [
        unit_num,
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
