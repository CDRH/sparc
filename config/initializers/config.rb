config_path = Rails.root.join("config", "config.yml")
config = YAML.load_file(config_path)[Rails.env]

SETTINGS = config["settings"]
