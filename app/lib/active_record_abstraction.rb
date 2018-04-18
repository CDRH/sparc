require 'active_support/concern'

module ActiveRecordAbstraction
  extend ActiveSupport::Concern

  included do
    def abstraction_nav
      markup = ""
      ABSTRACT["nav"].each do |category, info|
        label = info["label"].present? ? info["label"] : category.titleize
        path = info["path"].present? ? send(info["path"]) :
          query_category_path(category)
        link_markup = content_tag "li", link_to(label, path),
          class: active?(params[:category], category), role: "presentation"
        markup << link_markup
      end
      sanitize markup
    end

    def abstraction_subnav
      markup =
        '<ul class="nav nav-pills buffer-bottom nav-justified query_subnav">'
      ABSTRACT["nav"][params[:category]].each do |subcat, info|
        label = info["label"].present? ? info["label"] : subcat.titleize
        path = info["path"].present? ? send(info["path"]) :
          query_form_path(params[:category], subcat)
        link_markup = content_tag "li", link_to(label, path),
          class: active?(params[:subcat], subcat), role: "presentation"
        markup << link_markup
      end
      markup << '</ul>'
      sanitize markup
    end

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
          res = result.send(table).map { |r| r.send(column) }.uniq.sort.join("; ")
        end
      else
        res = result[column].present? ? result[column] : ""
      end
      res
    end

    def table_label
      category = ABSTRACT["nav"][params[:category]]
      if category["singular"]
        category["label"].present? ?
          category["label"] : params[:category].titleize
      else
        subcat = category[params[:subcat]]
        if subcat["singular"]
          subcat["label"].present? ? subcat["label"] : params[:subcat].titleize
        elsif subcat[params[:table]] && subcat[params[:table]]["label"].present?
          subcat[params[:table]]["label"]
        else
          params[:table].titleize
        end
      end
    end
  end

  module ClassMethods
  end
end
