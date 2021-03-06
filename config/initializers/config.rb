config_path = Rails.root.join("config", "config.yml")
config = YAML.load_file(config_path)[Rails.env]

SETTINGS = config["settings"]

if SETTINGS["iiif_server"].blank?
  raise "Please fill out settings.iiif_server in config.yml file."
end

if SETTINGS["thumbnail_size"].blank?
  raise "Please fill out settings.thumbnail_size in config.yml file."
end
