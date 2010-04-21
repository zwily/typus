module Admin

  module FiltersHelper

    def filters

      typus_filters = @resource[:class].typus_filters
      return if typus_filters.empty?

      current_request = request.env['QUERY_STRING'] || []

      filters = typus_filters.map do |key, value|
        case value
        when :boolean then boolean_filter(current_request, key)
        when :string then string_filter(current_request, key)
        when :date, :datetime then date_filter(current_request, key)
        when :belongs_to then relationship_filter(current_request, key)
        when :has_many || :has_and_belongs_to_many then
          relationship_filter(current_request, key, true)
        when nil then
          # Do nothing. This is ugly but for now it's ok.
        else
          string_filter(current_request, key)
        end
      end

      html = <<-HTML
<div id="filters">
  <ul>
    #{filters}
  </ul>
</div>
      HTML

      return html

    end

    def build_filters(filter, items)
      render "admin/helpers/filters", :items => items, :attribute => filter
    end

    def relationship_filter(request, filter, habtm = false)
      att_assoc = @resource[:class].reflect_on_association(filter.to_sym)
      class_name = att_assoc.options[:class_name] || ((habtm) ? filter.classify : filter.capitalize.camelize)
      model = class_name.constantize
      related_fk = (habtm) ? filter : att_assoc.primary_key_name

      params_without_filter = params.dup
      %w( controller action page ).each { |p| params_without_filter.delete(p) }
      params_without_filter.delete(related_fk)

      items = {}
      model.all(:order => model.typus_order_by).each do |m|
        items[m.id] = m.to_label
      end

      build_filters(filter, items)
    end

    def date_filter(request, filter)

      items = {}

      # if !@resource[:class].typus_field_options_for(:filter_by_date_range).include?(filter.to_sym)
      %w( today last_few_days last_7_days last_30_days ).map do |timeline|
        # switch = request.include?("#{filter}=#{timeline}") ? 'on' : 'off'
        # options = { :page => nil }
        #if switch == 'on'
        #  params.delete(filter)
        #else
        #  options.merge!(filter.to_sym => timeline)
        #end
        items[timeline] = _(timeline.humanize)
        # link_to _(timeline.humanize), params.merge(options), :class => switch
      end
      build_filters(filter, items)
        #, :attribute => filter)
      # else
      #  date_params = params.dup

      #  %w( action controller page id ).each { |p| date_params.delete(p) }
      #  date_params.delete(filter)

      #  hidden_params = date_params.map { |k, v| hidden_field_tag(k, v) }
      #  render "admin/helpers/date", :hidden_params => hidden_params, :filter => filter, :resource => @resource
      # end

    end

    def boolean_filter(request, filter)
      items = @resource[:class].typus_boolean(filter)
      build_filters(filter, items)
    end

    def string_filter(request, filter)
      values = @resource[:class]::const_get("#{filter.to_s.upcase}")

      if values.kind_of?(Hash)
        items = values.invert
      else
        items = {}
        values.each do |value|
          items[value] = value
        end
      end

      build_filters(filter, items)
    end

  end

end
