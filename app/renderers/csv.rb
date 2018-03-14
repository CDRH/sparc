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
    obj << row.attributes.map { |column, value| display_value(row, column) }.compact
    # raise "exception #{row.attributes.map { |column, value| display_values(row, column) }.compact}"
  end
  str = obj.map(&:to_csv).join
  send_data str, type: Mime[:csv],
    disposition: "attachment; filename=#{filename}.csv"
end
