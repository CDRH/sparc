ActionController::Renderers.add :csv do |data, options|
  filename = options[:filename] || 'data'
  filename << ".csv"

  csv_data = CSV.generate(headers: true) do |csv|
    # Use specified column names if passed, otherwise use record field names
    headers = options[:columns] || data[0].attributes.keys
    csv << headers.map { |header| header.titleize }

    data.each do |row|
      csv << row.attributes.map { |column, value| display_value(row, column) }
        .compact
    end
  end
  send_data csv_data, filename: filename
end
