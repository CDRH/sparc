@@columns_to_remove = [
  "id",
  "created_at",
  "updated_at"
]

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
    record = remove_columns(row.attributes)
    record = association_labels(record)
    obj << record.values
  end
  str = obj.map(&:to_csv).join
  send_data str, type: Mime[:csv], disposition: "attachment; filename=#{filename}.csv"
end

def association_labels(record)
  record.each do |column, value|
    if column[/_id$/]
      # get name without _id
      assoc_col = column[/^(.+)_id$/, 1]
      if record.respond_to?(assoc_col)
        if record.send(assoc_col).present?
          if record.send(assoc_col).respond_to?(:name)
            record[column] = record.send(assoc_col).name
          else
            record[column] = record.send(assoc_col).id
          end
        else
          record[column] = "N/A"
        end
      else
        if record.send(assoc_col.pluralize).present?
          assoc_values = result.send(assoc_col.pluralize)
            .map { |r| r.send(assoc_col << "_no") }.join("; ")
          record[column] = assoc_values
        else
          record[column] = "N/A"
        end
      end
    end
  end
end

# accepts both Array and Hash
def remove_columns(data, columns=@@columns_to_remove)
  if data.class == Array
    return data - columns
  else
    # assuming that it's a hash
    return data.reject { |k, v| columns.include?(k) }
  end
end
