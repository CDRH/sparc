@@columns_to_remove = [
  "id",
  "created_at",
  "updated_at"
]

# accepts both Array and Hash
def remove_columns(data, columns=@@columns_to_remove)
  if data.class == Array
    return data - columns
  else
    # assuming that it's a hash
    return data.reject { |k, v| columns.include?(k) }
  end
end

ActionController::Renderers.add :csv do |data, options|
  filename = options[:filename] || 'data'
  obj = []
  # start with specified column names if they exist
  if options[:columns]
    obj << remove_columns(options[:columns])
  else
    obj << remove_columns(row.attributes.keys)
  end
  # add the values from each active record object to the array
  data.each do |row|
    attributes = remove_columns(row.attributes)
    obj << attributes.values
  end
  str = obj.map(&:to_csv).join
  send_data str, type: Mime[:csv], disposition: "attachment; filename=#{filename}.csv"
end
