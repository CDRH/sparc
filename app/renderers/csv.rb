ActionController::Renderers.add :csv do |data, options|
  filename = options[:filename] || 'data'
  filename << ".csv"

  csv_data = CSV.generate(headers: true) do |csv|
    # Use specified column names if passed, otherwise use record field names

    # add occupation column if not present
    no_occupation = !@table_fields.map{ |f| f[:name] }.include?("occupation")

    header = []
    if options[:occupation_source].present? && no_occupation
      header.push(options[:occupation_source])
    end
    labels = options[:table_fields].map { |field| field_label(field) }
    csv << header.push(*labels)

    data.each do |result|
      row = []
      if options[:occupation_source].present? && no_occupation
        row.push(Occupation.where(id: result[:occupation_id]).first.name)
      end
      values = options[:table_fields].map do |field|
        display_value(result, field[:name], field[:assoc])
      end
      csv << row.push(*values)
    end
  end
  send_data csv_data, filename: filename
end
