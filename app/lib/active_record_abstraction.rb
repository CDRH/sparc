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

    def collect_fields(table)
      # Return cached abstraction if already processed
      return ABSTRACT[table.to_s] if ABSTRACT.key?(table.to_s)

      table_fields = []

      table.columns.each do |c|
        table_fields << { assoc: :column, name: c.name.to_s }
      end

      # Collect association fields
      table.reflect_on_all_associations(:belongs_to).each do |a|
        # Remove ID column and use association instead
        table_fields = table_fields.reject { |f| f[:name] == "#{a.name}_id" }

        table_fields << { assoc: :belongs_to, name: a.name.to_s }
      end

      table.reflect_on_all_associations(:has_and_belongs_to_many).each do |a|
        table_fields << { assoc: :habtm, name: a.name.to_s }
      end

      %i[has_many has_one].each do |as|
        table.reflect_on_all_associations(as).each do |a|
          table_fields << { assoc: as, name: a.name.to_s }
        end
      end

      table_fields = remove_skip_fields(table_fields)
      table_fields = remove_sensitive_records(table_fields)
      table_fields = apply_form_abstraction(table, table_fields)

      # Cache abstraction so only processed once
      ABSTRACT[table.to_s] = table_fields

      table_fields
    end

    def display_forms(fields)
      markup = ''
      fields.each do |field|
        # because units is a common search option, do not add to display form
        # TODO move to abstaction config file when hidden form fields created
        next if field[:name] == "units"
        markup << <<-HTML
<div class="col-md-6">
  <div class="form-group">
        HTML

        label_markup = label_tag field[:name], field_label(field)
        markup << label_markup

        if field[:form] == :input
          form_markup = text_field_tag field[:name], params[field[:name]],
            class: "form-control"
        elsif field[:form] == :select
          if field[:assoc] == :column
            form_markup = select_tag field[:name],
              options_for_select(
                pluck_column_for_select(@table_class, field[:name]),
                params[field[:name]]
              ), class: "form-control", include_blank: true
          else
            # Associations
            assoc_model = field[:name].classify.constantize
            form_markup = select_tag field[:name],
              options_from_collection_for_select(
                assoc_model.distinct.order(association_column(assoc_model)),
                "id", association_column(assoc_model), params[field[:name]]
              ), class: "form-control", include_blank: true
          end
        end
        markup << form_markup

        markup << <<-HTML
  </div>
</div>
        HTML
      end
      sanitize markup, tags: %w[div input label select option],
        attributes: %w[class for id label name selected type value]
    end

    def display_value(result, column, assoc)
      value = ""

      if assoc == :column
        value = result[column].present? ? result[column] : ""
      else
        if result.send(column).present?
          assoc_col = association_column(column)
          if result.send(column).respond_to?(assoc_col)
            if result.send(column).respond_to?(:map)
              value = result.send(column)
                .map { |r| r.send(assoc_col) }.uniq.join("; ")
            else
              value = result.send(column).send(assoc_col)
            end
          else
            value = result.send(column)
              .map { |r| r.send(assoc_col) }.uniq.join("; ")
          end
          value = "#{value} (DB ID)" if assoc_col == "id"
        else
          value = "N/A"
        end
      end
      value
    end

    def field_label(field)
      label = field.key?(:label) ? field[:label].clone : field[:name].titleize
      if field[:assoc] != :column
        assoc_col = association_column(field[:name])
        assoc_label =
          ABSTRACT.dig(field[:name].classify, :labels, field[:name])
        assoc_label = assoc_label ? assoc_label : assoc_col.titleize

        label << " (#{assoc_label})"
      end
      label
    end

    def search_fields(table, fields)
      res = table.unscoped
      table_name = table.model_name.plural
      fields.each do |field|
        if field[:assoc] == :column
          if params[field[:name]].present?
            if field[:form] == :input
              if table.column_for_attribute(field[:name]).type == :string ||
                 table.column_for_attribute(field[:name]).type == :text
                   res = res.where("#{table_name}.#{field[:name]} LIKE ?",
                                "%#{params[field[:name]]}%")
              else
                res = res.where("#{table_name}.#{field[:name]} = ?",
                                "#{params[field[:name]]}")
              end
            elsif field[:form] == :select
              res = res.where("#{table_name}.#{field[:name]} = ?",
                              "#{params[field[:name]]}")
            end
          end
        elsif %i[belongs_to habtm has_many has_one].include?(field[:assoc])
          if params[field[:name]].present?
            if field[:form] == :select
              res = res.joins(field[:name].to_sym)
                .where(field[:name].pluralize => { id: params[field[:name]] })
            elsif field[:form] == :input
              if field[:name].classify.constantize
                .column_for_attribute(association_column(field[:name]))
                .type == :string
                query_string = "#{field[:name].pluralize}" <<
                  ".#{association_column(field[:name])} LIKE ?"
                res = res.joins(field[:name].to_sym)
                  .where(query_string, "%#{params[field[:name]]}%")
              else
                res = res.joins(field[:name].to_sym).where(
                  "#{table_name}.#{field[:name].pluralize}" => {
                    association_column(field[:name]) => params[field[:name]]
                  }
                )
              end
            end
          else
            res = res.includes(field[:name].to_sym)
          end
        end
      end
      res
    end

    def table_description
      sanitize params[:table].classify.constantize
        .abstraction[:description]
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

    private

    def apply_form_abstraction(table, fields)
      if table.abstraction.key?(:disabled)
        fields = fields.reject do |f|
          table.abstraction[:disabled].include?(f[:name])
        end
      end

      if table.abstraction.key?(:labels)
        fields = fields.each do |f|
          if table.abstraction[:labels].key?(f[:name].to_sym)
            f[:label] = table.abstraction[:labels][f[:name].to_sym]
          end
        end
      end

      if table.abstraction.key?(:selects)
        fields = fields.each do |f|
          if table.abstraction[:selects].include?(f[:name]) ||
            field_is_selectable_column?(table, f) ||
            field_is_selectable_assoc?(table, f)
            f[:form] = :select
          else
            f[:form] = :input
          end
        end
      end

      organized_fields = { primary: [], other: [] }

      # Separate primary fields as defined in model abstraction
      table.abstraction[:primary].each do |p_field|
        fields.each do |f|
          if f[:name] == p_field
            organized_fields[:primary] << f
            fields.delete(f)
          end
        end
      end

      # Alphabetize other fields
      fields.sort! { |a, b| a[:name] <=> b[:name] }
      organized_fields[:other].concat(fields)

      organized_fields
    end

    def association_column(model)
      model = model.classify.constantize if model.class == String

      if model.respond_to?("abstraction") &&
        model.abstraction[:assoc_col].present?

        model.abstraction[:assoc_col]
      elsif model.column_for_attribute(:name).table_name.present?
        "name"
      else
        "id"
      end
    end

    def field_is_selectable_assoc?(table, field)
      if field[:assoc] != :column
        assoc = field[:name].classify.constantize

        if assoc.select(association_column(assoc)).distinct
          .count < ABSTRACT["select_limit"]

          return true
        end
      end
      false
    end

    def field_is_selectable_column?(table, field)
      field[:assoc] == :column &&
        table.select(field[:name]).distinct.count < ABSTRACT["select_limit"]
    end

    def in_skip_list?(name, skip_list)
      if skip_list.present?
        skip_list.each do |skip|
          if skip.class == String
            if name == skip
              return true
            end
          elsif skip.class == Regexp
            if name.match?(skip)
              return true
            end
          end
        end
      end
      false
    end

    def pluck_column_for_select(table, column)
      Array(table.pluck(column)).compact.uniq
        .sort do |a, b|
          # Sort doesn't handle boolean values by default
          if a.class == FalseClass || a.class == TrueClass
            if (a.class == FalseClass && b.class == FalseClass) ||
              (a.class == TrueClass && b.class == TrueClass)
              0
            else
              a.class == FalseClass && b.class == TrueClass ? 1 : -1
            end
          else
            a <=> b
          end
        end
    end

    def remove_sensitive_records(fields)
      if SETTINGS["hide_sensitive_image_records"]
        fields = fields.reject { |f| f[:name] == "image_human_remain" }
      end
      fields
    end

    def remove_skip_fields(fields)
      skips = ABSTRACT["skip_fields"]
      fields.reject do |field|
        group = field[:assoc]
        name = field[:name]

        in_skip_list?(name, skips["app_wide"]) ||
        (group == :belongs_to && in_skip_list?(name, skips["belongs_to"])) ||
        (group == :column && in_skip_list?(name, skips["column"])) ||
        (group == :habtm && in_skip_list?(name, skips["habtm"])) ||
        (group == :has_many && in_skip_list?(name, skips["has_many"])) ||
        (group == :has_one && in_skip_list?(name, skips["has_one"]))
      end
    end
  end

  module ClassMethods
  end
end
