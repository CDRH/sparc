IMG_LOC = "#{Rails.root}/app/assets/images/field"
LOG_LOC = "#{Rails.root}/reports"

namespace :images do

  desc "find images with missing files"
  task find_missing: :environment do
    missing = []
    images = Image.pluck(:image_no)
    images.each do |image|
      # check thumbnail
      if !File.file?("#{IMG_LOC}/thumb/#{image}.jpg")
        missing << "thumb/#{image}"
      end
      # check large image
      if !File.file?("#{IMG_LOC}/large/#{image}.jpg")
        missing << "large/#{image}"
      end
    end
    puts "Found #{missing.length} missing images, please see #{LOG_LOC}/images_missing.txt for information"
    File.open("#{LOG_LOC}/images_missing.txt", "w") do |file|
      file.write(missing.join("\n"))
    end
  end

  desc "find images not described in database"
  task find_extra: :environment do
    extra = []
    images = Dir["#{IMG_LOC}/**/*.jpg"]
    images.each do |image|
      id = File.basename(image, ".*")
      extra << id if Image.find_by(image_no: id).nil?
    end
    puts "Found #{extra.length} extra images, please see #{LOG_LOC}/images_extra.txt for information."
    File.open("#{LOG_LOC}/images_extra.txt", "w") do |file|
      file.write(extra.uniq.join("\n"))
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

