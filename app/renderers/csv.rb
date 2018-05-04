ActionController::Renderers.add :csv do |data, options|
  filename = options[:filename] || 'data'
  filename << ".csv"

  csv_data = CSV.generate(headers: true) do |csv|
    # Use specified column names if passed, otherwise use record field names
    csv << options[:table_fields].map { |field| field_label(field) }

    data.each do |result|
      csv << options[:table_fields].map do |field|
        display_value(result, field[:name], field[:assoc])
      end
    end
  end
  send_data csv_data, filename: filename
end
