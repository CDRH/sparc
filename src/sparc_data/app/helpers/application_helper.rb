module ApplicationHelper
  def feature_feature_no_column(record, column)
    "#{record.feature_no.to_i if record.feature_no}"
  end
end
