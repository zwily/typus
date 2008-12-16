module AdminSidebarHelper

  def actions

    html = ""

    ##
    # Add
    #
    case params[:action]
    when 'index', 'edit', 'update'
      if @current_user.can_perform?(@resource[:class], 'create')
        html << <<-HTML
<ul>
<li>#{link_to "Add #{@resource[:class_name_humanized].downcase}", :action => 'new'}</li>
</ul>
        HTML
      end
    end

    ##
    # Edit, update ...
    #
    case params[:action]
    when 'edit', 'update'
      html << <<-HTML
<ul>
<li>#{link_to "Next", :id => @next.id if @next}</li>
<li>#{link_to "Previous", :id => @previous.id if @previous}</li>
</ul>
      HTML
    end

    ##
    # index, update, create
    #
    case params[:action]
    when 'new', 'create'
      html << <<-HTML
<ul>
<li>#{link_to "Back to list", :action => 'index'}</li>
</ul>
      HTML
    else
      html << more_actions
      html << block('parent_module')
      html << block('submodules')
    end

    html = "<h2>Actions</h2>\n#{html}" unless html.empty?
    return html

  end

  def more_actions
    html = ""
    @resource[:class].typus_actions_for(params[:action]).each do |action|
      if @current_user.can_perform?(@resource[:class], action)
        html << "<li>#{link_to action.titleize.capitalize, :action => action}</li>"
      end
    end
    html = "<ul>#{html}</ul>" unless html.empty?
    return html
  end

  def block(name)

    models = case name
             when 'parent_module': Typus.parent(@resource[:class_name], 'module')
             when 'submodules':    Typus.module(@resource[:class_name])
             else []
    end

    html = ""
    models.each do |m|
      model_cleaned = m.split(" ").join("").tableize
      html << "<li>#{link_to m, :controller => "admin/#{model_cleaned}"}</li>"
    end
    html = "<h2>#{name.humanize}</h2>\n<ul>#{html}</ul>" unless html.empty?

    return html

  end

  def search

    unless Typus::Configuration.config[@resource[:class_name]]['search'].nil?

      search_params = params.dup
      %w( action controller search page ).each { |p| search_params.delete(p) }

      hidden_params = []
      search_params.each { |key, value| hidden_params << hidden_field_tag(key, value) }

      search = <<-HTML
<h2>Search</h2>
<form action="" method="get">
<p><input id="search" name="search" type="text" value="#{params[:search]}"/></p>
#{hidden_params.join("\n")}
</form>
<p style="margin: -10px 0px 10px 0px;"><small>Searching by #{Typus::Configuration.config[@resource[:class_name]]['search'].split(', ').to_sentence(:skip_last_comma => true, :connector => '&').titleize.downcase}.</small></p>
      HTML

      return search

    end

  end

  def filters
    current_request = request.env['QUERY_STRING'] || []
    unless @resource[:class].typus_filters.empty?
      html = ""
      @resource[:class].typus_filters.each do |f|
        html << "<h2>#{f.first.humanize}</h2>\n"
        case f.last
        when 'boolean':      html << boolean_filter(current_request, f.first)
        when 'string':       html << string_filter(current_request, f.first)
        when 'datetime':     html << datetime_filter(current_request, f.first)
        when 'collection':   html << collection_filter(current_request, f.first)
        else
          html << "<p>Unknown</p>"
        end
      end
    end
    return html
  end

  def collection_filter(request, filter)
    model = filter.capitalize.camelize.constantize
    related_fk = @resource[:class].reflect_on_association(filter.to_sym).primary_key_name
    returning(String.new) do |html|
      html << "<p>No available #{model.name.titleize.pluralize.downcase}.</p>" and next if model.count.zero?
      related_items = model.find(:all, :order => model.typus_order_by)
      if related_items.size > Typus::Configuration.options[:sidebar_selector]
        items = []
        related_items.each do |item|
          switch = request.include?("#{related_fk}=#{item.id}") ? 'selected' : ''
          items << "<option #{switch} value=\"#{url_for params.merge(related_fk => item.id, :page => nil)}\">#{item.typus_name}</option>"
        end
        html << <<-HTML
<!-- Embedded JS -->
<script>
function surfto_#{model.name.downcase.pluralize}(form) {
  var myindex = form.#{model.name.downcase.pluralize}.selectedIndex
  if (form.#{model.name.downcase.pluralize}.options[myindex].value != "0") {
    top.location.href = form.#{model.name.downcase.pluralize}.options[myindex].value;
  }
}
</script>
<!-- /Embedded JS -->
<p><form class="form" action="#">
  <select name="#{model.name.downcase.pluralize}" onChange="surfto_#{model.name.downcase.pluralize}(this.form)">
    <option value=\"#{url_for}\">Filter by #{model.name.titleize.humanize}</option>
    #{items.join("\n")}
  </select>
</form></p>
        HTML
      else
        items = []
        related_items.each do |item|
          switch = request.include?("#{related_fk}=#{item.id}") ? 'on' : 'off'
          items << "<li>#{link_to item.typus_name, { :params => params.merge(related_fk => item.id, :page => nil) }, :class => switch }</li>"
        end
        html << <<-HTML
<ul>
#{items.join("\n")}
</ul>
        HTML
      end
    end
  end

  def datetime_filter(request, filter)
    returning(String.new) do |html|
      items = []
      %w( today past_7_days this_month this_year ).each do |timeline|
        switch = request.include?("#{filter}=#{timeline}") ? 'on' : 'off'
        items << "<li>#{link_to timeline.titleize, { :params => params.merge(filter => timeline, :page => nil) }, :class => switch}</li>"
      end
      html << <<-HTML
<ul>
#{items.join("\n")}
</ul>
      HTML
    end
  end

  def boolean_filter(request, filter)
    returning(String.new) do |html|
      items = []
      @resource[:class].typus_boolean(filter).each do |key, value|
        switch = request.include?("#{filter}=#{value}") ? 'on' : 'off'
        items << "<li>#{link_to value, { :params => params.merge(filter => key, :page => nil) }, :class => switch}</li>"
      end
      html << <<-HTML
<ul>
#{items.join("\n")}
</ul>
      HTML
    end
  end

  def string_filter(request, filter)
    values = @resource[:class].send(filter)
    returning(String.new) do |html|
      unless values.empty?
        items = []
        values.each do |item|
          switch = request.include?("#{filter}=#{item}") ? 'on' : 'off'
          items << "<li>#{link_to item.capitalize, { :params => params.merge(filter => item, :page => nil) }, :class => switch }</li>"
        end
        html << <<-HTML
<ul>
#{items.join("\n")}
</ul>
        HTML
      else
        html << "<p>No available #{filter}.</p>"
      end
    end
  end

end