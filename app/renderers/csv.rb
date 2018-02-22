ActionController::Renderers.add :csv do |data, options|
  filename = options[:filename] || 'data'
  obj = []
  # start with specified column names if they exist, otherwise default to record fields
  columns = options[:columns] || data[0].attributes.keys
  # filter out those which shouldn't be displayed and titleize
  # TODO move similar logic out of results html view so both use
  obj << columns.reject { |column| column[/(?:^id|_at)$/] }
          .map { |column| column.titleize }

  # add the values from each active record object to the array
  data.each do |row|
    obj << row.attributes.map { |column, value| display_values(row, column) }.compact
    # raise "exception #{row.attributes.map { |column, value| display_values(row, column) }.compact}"
  end
  str = obj.map(&:to_csv).join
  send_data str, type: Mime[:csv],
    disposition: "attachment; filename=#{filename}.csv"
end

# TODO this is a copy of the display_values method in the query_helper.rb file and should be condensed
def display_values(record, column)
  value = record[column]
  if column[/_id$/]
    # get name without _id
    assoc_col = column[/^(.+)_id$/, 1]
    if record.respond_to?(assoc_col)
      if record.send(assoc_col).present?
        if record.send(assoc_col).respond_to?(:name)
          value = record.send(assoc_col).name
        else
          value = record.send(assoc_col).id
        end
      else
        value = "N/A"
      end
    else
      # TODO check for respond_to? here, also?
      if record.send(assoc_col.pluralize).present?
        assoc_values = record.send(assoc_col.pluralize)
          .map { |r| r.send(assoc_col << "_no") }.join("; ")
        value = assoc_values
      else
        value = "N/A"
      end
    end
  # let through columns that aren't "id" or "created_at", etc
  elsif !column[/(?:^id|_at)$/]
    # if the value is "nil" then sub in empty string so it will display correctly
    value = "" if value.nil?
  else
    value = nil
  end
  return value
end
