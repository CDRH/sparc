namespace :tables do
  desc "Counts non-join records"
  task count_records: :environment do
    Rails.application.eager_load!
    models = ActiveRecord::Base.subclasses.map(&:name)
    puts "There are #{models.length} total tables in the database"

    records = 0

    models.each do |model|
      begin
        next if model.include?("HABTM")
        next if ["ActiveRecord::SessionStore::Session", "ActiveScaffold::Tableless", "User", "ApplicationRecord", "FeatureStratum"].include?(model)
        count = model.constantize.count
        puts "#{model}: #{count}"
        records += count
      rescue => e
        puts e
      end
    end

    puts "There are #{records} total records in the database"
  end

end
