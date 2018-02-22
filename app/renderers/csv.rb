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

# TODO this is a copy of the display_values method in the query_helper.rb file and should be condensed
def display_value(result, column)
  res = column
  if column[/_id$/]
    assoc_col = column[/^(.+)_id$/, 1]
    if assoc_col == "occupation"
      res = Occupation.where(id: result[:occupation_id]).first.name
    elsif result.respond_to?(assoc_col)
      if result.send(assoc_col).present?
        if result.send(assoc_col).respond_to?(:name)
          res = result.send(assoc_col).name
        else
          res = result.send(assoc_col).id
        end
      else
        res = "N/A"
      end
    elsif result.respond_to?(assoc_col.pluralize)
      if result.send(assoc_col.pluralize).present?
        assoc_obj = result.send(assoc_col.pluralize)
        if assoc_obj.first.respond_to?("name")
          res = assoc_obj.map { |r| r.name }.join("; ")
        elsif assoc_obj.first.respond_to?(assoc_col << "_no")
          res = assoc_obj.map { |r| r.send(assoc_col << "_no") }
            .join("; ")
        elsif assoc_obj.first.respond_to?("id")
          res = assoc_obj.map { |r| r.id }.join("; ")
        end
      else
        res = "N/A"
      end
    else
      res = "N/A"
    end
  elsif !column[/(?:^id|_at)$/]
    res = result[column]
  end
  res
end
