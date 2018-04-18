config_abstraction_path = Rails.root.join("config", "abstraction.yml")
ABSTRACT = YAML.load_file(config_abstraction_path)[Rails.env]

if ABSTRACT["nav"].blank?
  raise "Please define 'nav' structure in config/abstraction.yml file."
end
