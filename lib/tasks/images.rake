LOG_LOC = "#{Rails.root}/reports"

namespace :images do

  desc "flag images file_exists column"
  task file_exists: :environment do
    res = { exists: 0, dne: 0 }
    report = "#{LOG_LOC}/all_mediaserver_images.txt"
    if File.file?(report)
      fs = IO.readlines(report).map(&:chomp)
      Image.all.each do |image|
        exists = fs.include?(image.filepath)
        image.update_attributes(file_exists: exists)
        exists ? res[:exists] += 1 : res[:dne] += 1
      end
      puts "Updated images #{res}"
    else
      puts "Unable to find #{report}, please regenerate"
      puts "    Run following from iiif/sparc directory:"
      puts "    find field polaroids -type f > all_mediaserver_images.txt"
    end
  end

  desc "report missing and extra images"
  task report_missing: :environment do
    report = "#{LOG_LOC}/all_mediaserver_images.txt"
    if File.file?(report)
      puts "Processing filesystem report"
      fs = IO.readlines(report).map(&:chomp)
      puts "    #{fs.uniq.length} images found in media server"
      puts "Retrieving database records"
      db = Image.unscoped.all.map { |i| i.filepath }
      puts "    #{db.length} image records found in database"
      puts "    (#{db.uniq.length} image records in database have unique image_no)"
      only_in_db = db - fs
      not_in_db = fs - db
      not_uniq = db.group_by { |x| x }.select { |k, v| v.size > 1 }.map(&:first)
      File.open("#{LOG_LOC}/images_missing.txt", "w") do |f|
        f.write(only_in_db.join("\n"))
      end
      File.open("#{LOG_LOC}/images_no_record.txt", "w") do |f|
        f.write(not_in_db.join("\n"))
      end
      File.open("#{LOG_LOC}/images_non_unique_record.txt", "w") do |f|
        f.write(not_uniq.join("\n"))
      end
      puts "#{only_in_db.length} records are missing files"
      puts "#{not_in_db.length} files do not have matching records"
      puts "Check the logs for complete lists of the above"
    else
      puts "Unable to find #{report}, please regenerate"
      puts "    Run following from iiif/sparc directory:"
      puts "    find field polaroids -type f > all_mediaserver_images.txt"
    end
  end

  desc "return list of remains and burials"
  task list_remains: :environment do
    burials = Image
      .includes(:image_human_remain, :image_subjects)
      .select { |i| !i.displayable? }
      .map { |b| b.filepath }
    puts "Writing list of non-displayable images to reports"
    File.open("#{LOG_LOC}/images_remains.txt", "w") do |file|
      file.write(burials.join("\n"))
    end
  end

end

