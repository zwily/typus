module AdminHelper

  include TypusHelper

  def typus_block(name)
    render :partial => "admin/#{@model.name.tableize}/#{name}" rescue nil
  end

  def actions

    html = ""

    ##
    # Add
    #
    case params[:action]
    when 'index', 'edit', 'update'
      if @current_user.can_create? @model
        html << "<ul>"
        html << "<li>#{link_to "Add #{@model.name.titleize.downcase}", :action => 'new'}</li>"
        html << "</ul>"
      end
    end

    ##
    # Edit, update ...
    #
    case params[:action]
    when 'edit', 'update'
      html << "<ul>\n"
      html << "<li>#{link_to "Next", :params => params.merge(:action => 'edit', :id => @next.id, :search => nil)}</li>" if @next
      html << "<li>#{link_to "Previous", :params => params.merge(:action => 'edit', :id => @previous.id, :search => nil)}</li>" if @previous
      html << "</ul>"
    end

    ##
    # index, update, create
    #
    case params[:action]
    when 'new', 'create'
      html << "<ul>"
      html << "<li>#{link_to "Back to list", :params => params.merge(:action => 'index')}</li>"
      html << "</ul>"
    else
      html << more_actions
      html << modules
      html << submodules
    end

    html = "<h2>Actions</h2>\n#{html}" unless html.empty?
    return html

  end

  def more_actions
    html = ""
    @model.typus_actions_for(params[:action]).each do |action|
      html << "<li>#{link_to action.titleize.capitalize, :params => params.merge(:action => action)}</li>"
    end
    html = "<ul>#{html}</ul>" unless html.empty?
    return html
  end

  def modules
    html = ""
    Typus.parent_module(@model.name).each do |m|
      model_cleaned = m.split(" ").join("").tableize
      html << "<li>#{ link_to m, :controller => "typus", :model => model_cleaned }</li>"
    end
    html = "<h2>Modules</h2>\n<ul>#{html}</ul>" unless html.empty?
    return html
  end

  def submodules
    html = ""
    Typus.submodules(@model.name).each do |m|
      model_cleaned = m.split(" ").join("").tableize
      html << "<li>#{ link_to m, :controller => "typus", :model => model_cleaned }</li>"
    end
    html = "<h2>Submodules</h2>\n<ul>#{html}</ul>" unless html.empty?
    return html
  end

  def search
    return "" if Typus::Configuration.config[@model.name]['search'].nil?
    search = <<-HTML
      <h2>Search</h2>
      <form action="" method="get">
      <p><input id="search" name="search" type="text" value="#{params[:search]}"/></p>
      </form>
      <p style="margin: -10px 0px 10px 0px;"><small>Searching by #{Typus::Configuration.config[@model.name]['search'].split(', ').join(', ').titleize.downcase}.</small></p>
    HTML
    return search
  end

  def filters
    current_request = request.env['QUERY_STRING'] || []
    if @model.typus_filters.size > 0
      html = ""
      @model.typus_filters.each do |f|
        html << "<h2>#{f[0].humanize}</h2>\n"
        case f[1]
        when 'boolean'
          html << "<ul>\n"
          %w( true false ).each do |status|
            switch = (current_request.include? "#{f[0]}=#{status}") ? 'on' : 'off'
            html << "<li>#{link_to status.capitalize, { :params => params.merge(f[0] => status) }, :class => switch}</li>\n"
          end
          html << "</ul>\n"
        when 'datetime'
          html << "<ul>\n"
          %w( today past_7_days this_month this_year ).each do |timeline|
            switch = (current_request.include? "#{f[0]}=#{timeline}") ? 'on' : 'off'
            html << "<li>#{link_to timeline.titleize, { :params => params.merge(f[0] => timeline) }, :class => switch}</li>\n"
          end
          html << "</ul>\n"
        when 'integer'
          model = f[0].split("_id").first.capitalize.camelize.constantize
          if model.count > 0
            html << "<ul>\n"
            model.find(:all, :order => model.typus_order_by).each do |item|
              switch = (current_request.include? "#{f[0]}=#{item.id}") ? 'on' : 'off'
              html << "<li>#{link_to item.typus_name, { :params => params.merge(f[0] => item.id) }, :class => switch}</li>\n"
            end
            html << "</ul>\n"
          end
        when 'string'
          values = @model.send(f[0])
          html << "<ul>\n"
          values.each do |item|
            switch = (current_request.include? "#{f[0]}=#{item.last}") ? 'on' : 'off'
            html << "<li>#{link_to item.capitalize, { :params => params.merge(f[0] => item) }, :class => switch }</li>\n"
          end
          html << "</ul>\n"
        end
      end
    end
    return html
  end

  def display_link_to_previous
    message = "You're adding a new #{@model.name.downcase} to a model. "
    message << "Do you want to cancel it? <a href=\"#{params[:back_to]}\">Click Here</a>"
    "<div id=\"flash\" class=\"notice\"><p>#{message}</p></div>"
  end

  def typus_table(model = @model, fields = 'list', items = @items)

    html = "<table>"

    ##
    # Header of the table
    #
    html << "<tr>"
    model.typus_fields_for(fields).each do |column|
      order_by = column[0]
      sort_order = (params[:sort_order] == "asc") ? "desc" : "asc"
      html << "<th>#{link_to "<div class=\"#{sort_order}\">#{column[0].titleize.capitalize}</div>", { :params => params.merge( :order_by => order_by, :sort_order => sort_order) }}</th>"
    end
    html << "<th>&nbsp;</th>\n</tr>"

    ##
    # Body of the table
    #
    items.each do |item|

      html << "<tr class=\"#{cycle('even', 'odd')}\" id=\"item_#{item.id}\">"

      model.typus_fields_for(fields).each do |column|
        case column[1]
        when "boolean"
          image = "#{image_tag(status = item.send(column[0])? "admin/status_true.gif" : "admin/status_false.gif")}"
          if Typus::Configuration.options[:toggle]
            html << "<td width=\"20px\" align=\"center\">#{link_to image, { :params => params.merge(:controller => "admin/#{model.name.tableize}", :action => 'toggle', :field => column[0], :id => item.id) } , :confirm => "Change #{column[0]}?"}</td>"
          else
            html << "<td width=\"20px\" align=\"center\">#{image}</td>"
          end
        when "datetime"
          html << "<td>#{item.send(column[0]).to_s(:db)}</td>"
        when "collection"
          begin
            html << "<td>#{link_to item.send(column[0].split("_id").first).typus_name, :controller => "/admin/#{column[0].split("_id").first.pluralize}", :action => "edit", :id => item.send(column[0])}</td>"
          rescue
            html << "<td></td>"
          end
        when "tree"
          html << "<td>#{item.parent.typus_name if item.parent}</td>"
        when "position"
          html_position = []
          [["Up", "move_higher"], ["Down", "move_lower"]].each do |position|
            html_position << "#{link_to position.first, :params => params.merge(:controller => "admin/#{model.name.tableize}", :action => 'position', :id => item.id, :go => position.last)}"
          end
          html << "<td>#{html_position.join("/")}</td>"
        else # 'string', 'integer', 'selector'
          if model.typus_fields_for(fields).first == column
            html << "<td>#{link_to item.send(column[0]) || "", :params => params.merge(:controller => "admin/#{model.name.tableize}", :action => 'edit', :id => item.id)}</td>"
          else
            html << "<td>#{item.send(column[0])}</td>"
          end
        end
      end

      ##
      # This controls the action to perform. If we are on a model list we 
      # will remove the entry, but if we inside a model we will remove the 
      # relationship between the models.
      #
      # Only shown is the user can destroy items.
      #

      if @current_user.can_destroy? model

        case params[:action]
        when 'index'
          @perform = link_to image_tag("admin/trash.gif"), { :controller => "admin/#{model.name.tableize}", 
                                                             :action => 'destroy', 
                                                             :id => item.id }, 
                                                             :confirm => "Remove entry?", 
                                                             :method => :delete
        else
          @perform = link_to image_tag("admin/trash.gif"), { :controller => "admin/#{model.name.tableize}", 
                                                             :action => "unrelate", 
                                                             :id => item.id, 
                                                             :model => @model, 
                                                             :model_id => params[:id] }, 
                                                             :confirm => "Remove #{model.humanize.singularize.downcase} \"#{item.typus_name}\" from #{@model.name}?"
        end

      end

      html << "<td width=\"10px\">#{@perform}</td>\n</tr>"

    end

    html << "</table>"

  end

  def typus_form(fields = @item_fields)

    html = error_messages_for :item, :header_tag => "h3"

    fields.each do |field|

      ##
      # Read only fields.
      #
      if @model.typus_field_options_for(:read_only).include?(field[0])
        field[1] = 'read_only' if %w( edit ).include?(params[:action])
      end

      ##
      # Auto generated fields.
      #
      if @model.typus_field_options_for(:auto_generated).include?(field[0])
        field[1] = 'auto_generated' if %w( new edit ).include?(params[:action])
      end

      ##
      # Questions
      #
      if @model.typus_field_options_for(:questions).include?(field[0])
        question = true
      end

      ##
      # Labels
      #
      case field[0]
      when /file_name/
        attribute = field[0].split("_file_name").first
        content_type = @item.send("#{attribute}_content_type")
        case content_type
        when /image/
          html << "<p>#{link_to image_tag(@item.send(attribute).url(:thumb)), @item.send(attribute).url, :popup => ['Sanoke', 'height=461,width=692'], :style => "border: 1px solid #D3D3D3;"}</p>\n"
        when /flash/
          html << "<p>No preview available for an <strong>Adobe Flash</strong> file.</p>"
        else
          html << "<p>No preview available (#{content_type})</p>\n" if %w( index ).include? params[:action]
        end
      when /_id/
        html << "<p><label for=\"item_#{field[0]}\">#{field[0].titleize.capitalize} <small>#{link_to "Add a new #{field[0].titleize.downcase}", "/admin/#{field[0].titleize.tableize}/new?back_to=#{request.env['REQUEST_URI']}" }</small></label>\n"
      else
        comment = %w( read_only auto_generated ).include?(field[1]) ? (field[1] + " field").titleize : nil
        html << "<p><label for=\"item_#{field[0]}\">#{field[0].titleize.capitalize}#{"?" if question} <small>#{comment}</small></label>\n"
      end

      ##
      # Field Type
      #
      case field[1]
      when "boolean"
        html << "#{check_box :item, field[0]} Checked if active"
      when "file"
        html << "#{file_field :item, field[0].split("_file_name").first, :style => "border: 0px;"}"
      when "datetime"
        html << "#{datetime_select :item, field[0], { :minute_step => Typus::Configuration.options[:minute_step] }}"
      when "password"
        html << "#{password_field :item, field[0], :class => 'box'}"
      when "text"
        html << "#{text_area :item, field[0], :class => 'text', :rows => Typus::Configuration.options[:form_rows]}"
      when "tree"
        html << "<select id=\"item_#{field[0]}\" name=\"item[#{field[0]}]\">\n"
        html << %{<option value=""></option>}
        html << "#{expand_tree_into_select_field(@item.class.top)}"
        html << "</select>\n"
      when "selector"
        values = @item.class.send(field[0])
        html << "<select id=\"item_#{field[0]}\" name=\"item[#{field[0]}]\">"
        html << "<option value=\"\">Select a #{field[0].singularize}</option>"
        values.each do |value|
          html << "<option #{"selected" if @item.send(field[0]).to_s == value.to_s} value=\"#{value}\">#{value}</option>"
        end
        html << "</select>"
      when "collection"
        related = field[0].split("_id").first.capitalize.camelize.constantize
        html << "#{select :item, "#{field[0]}", related.find(:all).collect { |p| [p.typus_name, p.id] }.sort_by { |e| e.first }, :prompt => "Select a #{related.name.downcase}"}"
      when "read_only", "auto_generated"
        html << "#{text_field :item, field[0], :class => 'box', :readonly => 'readonly', :style => 'background: #FFFCE1;'}"
      else
        html << "#{text_field :item, field[0], :class => 'box'}"
      end
      html << "</p>\n"
    end
    return html
  end

  def typus_form_has_many
    html = ""
    if @item_has_many
      @item_has_many.each do |field|
        model_to_relate = field.singularize.camelize.constantize
        html << "<h2 style=\"margin: 20px 0px 10px 0px;\"><a href=\"/admin/#{field}\">#{field.titleize}</a> <small>#{link_to "Add new", "/admin/#{field}/new?back_to=#{request.env['REQUEST_URI']}&model=#{@model}&model_id=#{@item.id}"}</small></h2>"
        current_model = @model
        @items = @model.find(params[:id]).send(field)
        if @items.size > 0
          html << typus_table(@items[0].class, 'relationship', @items)
        else
          html << "<div id=\"flash\" class=\"notice\"><p>There are no #{field.titleize.downcase}.</p></div>"
        end
      end
    end
    return html
  end

  def typus_form_has_and_belongs_to_many
    html = ""
    if @item_has_and_belongs_to_many
      @item_has_and_belongs_to_many.each do |field|
        model_to_relate = field.singularize.camelize.constantize
        html << "<h2 style=\"margin: 20px 0px 10px 0px;\"><a href=\"/admin/#{field}\">#{field.titleize}</a> <small>#{link_to "Add new", "/admin/#{field}/new?back_to=#{request.env['REQUEST_URI']}&model=#{@model}&model_id=#{@item.id}"}</small></h2>"
        items_to_relate = (model_to_relate.find(:all) - @item.send(field))
        if items_to_relate.size > 0
          html << <<-HTML
            #{form_tag :action => 'relate'}
            #{hidden_field :related, :model, :value => field.modelize}
            <p>#{ select :related, :id, items_to_relate.collect { |f| [f.typus_name, f.id] }.sort_by { |e| e.first } }
          &nbsp; #{submit_tag "Add", :class => 'button'}
            </form></p>
          HTML
        end
        current_model = @model.name.singularize.camelize.constantize
        @items = current_model.find(params[:id]).send(field)
        html << typus_table(field.modelize, 'relationship') if @items.size > 0
      end
    end
    return html
  end

  ##
  # Tree when +acts_as_tree+
  #
  def expand_tree_into_select_field(categories)
    returning(String.new) do |html|
      categories.each do |category|
        html << %{<option #{"selected" if @item.parent_id == category.id} value="#{ category.id }">#{ "-" * category.ancestors.size } #{category.name}</option>}
        html << expand_tree_into_select_field(category.children) if category.has_children?
      end
    end
  end

  ##
  # Simple and clean pagination links
  #
  def windowed_pagination_links(pager, options)
    link_to_current_page = options[:link_to_current_page]
    always_show_anchors = options[:always_show_anchors]
    padding = options[:window_size]
    pg = params[:page].blank? ? 1 : params[:page].to_i
    current_page = pager.page(pg)
    html = ""
    ##
    # Calculate the window start and end pages
    #
    padding = padding < 0 ? 0 : padding
    first = pager.first.number <= (current_page.number - padding) && pager.last.number >= (current_page.number - padding) ? current_page.number - padding : 1
    last = pager.first.number <= (current_page.number + padding) && pager.last.number >= (current_page.number + padding) ? current_page.number + padding : pager.last.number
    ##
    # Print start page if anchors are enabled
    #
    html << yield(1) if always_show_anchors and not first == 1
    ##
    # Print window pages
    #
    first.upto(last) do |page|
      (current_page.number == page && !link_to_current_page) ? html << page.to_s : html << (yield(page)).to_s
    end
    ##
    # Print end page if anchors are enabled
    #
    html << yield(pager.last.number).to_s if always_show_anchors and not last == pager.last.number
    # return the html
    return html
  end

end