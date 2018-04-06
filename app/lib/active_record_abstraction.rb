require 'active_support/concern'

module ActiveRecordAbstraction
  extend ActiveSupport::Concern

  included do
    def display_value(result, column)
      return if column[/(?:^id|_at)$/]

      res = ""
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
      elsif column[/_(?:habtm|hm|join)$/]
        if column[/_(?:habtm|hm)$/]
          column = column[/^(.+)_(?:habtm|hm)$/, 1]

            res = result.send(column).map { |r| r.name }.uniq.sort.join("; ")
        elsif column[/_join$/]
          column = column[/^(.+)_join$/, 1]
          column, table = column.split("|")
          res = result.send(table).map { |r| r.feature_no }.uniq.sort.join("; ")
        end
      else
        res = result[column].present? ? result[column] : ""
      end
      res
    end
  end

  module ClassMethods
  end
end
