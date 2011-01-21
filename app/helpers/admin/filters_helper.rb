module Admin

  module FiltersHelper

    def build_filters(resource = @resource)
      typus_filters = resource.typus_filters

      return if typus_filters.empty?

      filters = typus_filters.map do |key, value|
        filter, items, message = case value
                                 when :boolean then boolean_filter(key)
                                 when :string then string_filter(key)
                                 when :date, :datetime then date_filter(key)
                                 when :belongs_to then relationship_filter(key)
                                 when :has_many, :has_and_belongs_to_many then
                                   relationship_filter(key, true)
                                 else
                                   string_filter(key)
                                 end

        items.insert(0, [message, ""])

        { :filter => filter, :items => items }
      end

      render "admin/helpers/filters/filters", :filters => filters
    end

    def relationship_filter(filter, habtm = false)
      att_assoc = @resource.reflect_on_association(filter.to_sym)
      class_name = att_assoc.options[:class_name] || ((habtm) ? filter.classify : filter.capitalize.camelize)
      model = class_name.typus_constantize
      related_fk = (habtm) ? filter : att_assoc.primary_key_name

      params_without_filter = params.dup
      %w(controller action page).each { |p| params_without_filter.delete(p) }
      params_without_filter.delete(related_fk)

      items = model.order(model.typus_order_by).map { |v| [v.to_label, v.id] }
      message = Typus::I18n.t("View all %{attribute}", :attribute => @resource.human_attribute_name(filter).downcase.pluralize)

      [related_fk, items, message]
    end

    def date_filter(filter)
      values  = %w(today last_few_days last_7_days last_30_days)
      items   = values.map { |v| [Typus::I18n.t(v.humanize), v] }
      message = Typus::I18n.t("Show all dates")
      [filter, items, message]
    end

    def boolean_filter(filter)
      values  = @resource.typus_boolean(filter)
      items   = values.map { |k, v| [Typus::I18n.t(k.humanize), v] }
      message = Typus::I18n.t("Show by %{attribute}", :attribute => @resource.human_attribute_name(filter).downcase)
      [filter, items, message]
    end

    def string_filter(filter)
      values = @resource::const_get(filter.to_s.upcase)

      items = case values
              when Hash
                values
              when Array
                if values.first.is_a?(Array)
                  keys, values = values.map { |i| i.first }, values.map { |i| i.last }
                  keys.to_hash_with(values)
                else
                  values.to_hash_with(values)
                end
              end

      items = items.to_a

      message = Typus::I18n.t("Show by %{attribute}", :attribute => @resource.human_attribute_name(filter).downcase)
      [filter, items, message]
    end

    def predefined_filters
      @predefined_filters ||= [["All", "index", "unscoped"]]
    end

  end

end
