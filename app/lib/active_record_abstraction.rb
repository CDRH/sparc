require 'active_support/concern'

module ActiveRecordAbstraction
  extend ActiveSupport::Concern

  included do
    def display_value(result, column)
      return if column[/(?:^id|_at)$/]

      res = ""
      if column[/_id$/]
        assoc_col = column[/^(.+)_id$/, 1]
        if assoc_col == "occupation" &&
          Occupation.where(id: result[:occupation_id]).present?
          res = Occupation.where(id: result[:occupation_id]).first.name
        elsif result.respond_to?(assoc_col)
          if result.send(assoc_col).present?
            if assoc_col.classify.constantize.respond_to?("abstraction")
              abstraction = assoc_col.classify.constantize.send("abstraction")
              res =
                result.send(assoc_col).send(abstraction[:assoc_input_column])
            elsif result.send(assoc_col).respond_to?(:name)
              res = result.send(assoc_col).name
            elsif result.send(assoc_col).respond_to?("#{assoc_col}_no")
              res = result.send(assoc_col).send("#{assoc_col}_no")
            elsif result.respond_to?("id")
              res = result.send(assoc_col).id.to_s << " (DB ID)"
            else
              res = "Assoc Info Missed"
            end
          else
            res = "N/A"
          end
        elsif result.respond_to?(assoc_col.pluralize)
          if result.send(assoc_col.pluralize).present?
            assoc_obj = result.send(assoc_col.pluralize)
            if assoc_obj.first.respond_to?("abstraction")
              abstraction = assoc_obj.send("abstraction")
              res =
                assoc_obj.map { |r| r.send(abstraction[:assoc_input_column]) }
                .uniq.join("; ")
            elsif assoc_obj.first.respond_to?("name")
              res = assoc_obj.map { |r| r.name }.uniq.join("; ")
            elsif assoc_obj.first.respond_to?("#{assoc_col}_no")
              res = assoc_obj.map { |r| r.send("#{assoc_col}_no") }
                .uniq.join("; ")
            elsif assoc_obj.first.respond_to?("id")
              res = assoc_obj.map { |r| r.id }.uniq.join("; ") << " (DB ID)"
            else
              res = "Pluralized Assoc Info Missed"
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

          if column.classify.constantize.respond_to?("abstraction")
            abstraction = column.classify.constantize.send("abstraction")
            res = result.send(column)
              .map { |r| r.send(abstraction[:assoc_input_column]) }
              .uniq.sort.join("; ")
          else
            res = result.send(column).map { |r| r.name }.uniq.sort.join("; ")
          end
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
