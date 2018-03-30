LOG_LOC = "#{Rails.root}/reports"

namespace :images do

  desc "find missing and extra images"
  task find_missing: :environment do
    report = "#{LOG_LOC}/all_mediaserver_images.txt"
    if File.file?(report)
      puts "Processing filesystem report"
      fs = IO.readlines(report).map(&:chomp)
      puts "    #{fs.uniq.length} images found in media server"
      puts "Retrieving database records"
      db = Image.all.map { |i| i.filepath }
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
    # refresh the list of displayable image_human_remain records in
    # case the criteria for matching them has changed
    ImageHumanRemain.all.each { |i| i.save }

    burials = Image
      .includes(:image_human_remain, :image_subjects)
      .select { |i| !i.displayable? }
      .map { |b| b.filepath }
    File.open("#{LOG_LOC}/images_remains.txt", "w") do |file|
      file.write(burials.join("\n"))
    end
  end

end

