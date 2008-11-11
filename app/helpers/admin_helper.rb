module AdminHelper

  include TypusHelper
  include TypusFormHelper
  include TypusTableHelper

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
      if @current_user.can_perform?(@model, 'create')
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
      html << block('parent_module')
      html << block('submodules')
    end

    html = "<h2>Actions</h2>\n#{html}" unless html.empty?
    return html

  end

  def more_actions
    html = ""
    @model.typus_actions_for(params[:action]).each do |action|
      if @current_user.can_perform?(@model, action)
        html << "<li>#{link_to action.titleize.capitalize, :params => params.merge(:action => action)}</li>"
      end
    end
    html = "<ul>#{html}</ul>" unless html.empty?
    return html
  end

  def block(name)

    models = case name
             when 'parent_module': Typus.parent(@model.name, 'module')
             when 'submodules':    Typus.module(@model.name)
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

    return "" if Typus::Configuration.config[@model.name]['search'].nil?

    search_params = params.dup
    %w( action controller search page ).each do |param|
      search_params.delete(param)
    end

    hidden_params = ""
    search_params.each do |key, value|
      hidden_params << "#{hidden_field_tag key, value}\n"
    end

    search = <<-HTML
<h2>Search</h2>
<form action="" method="get">
<p><input id="search" name="search" type="text" value="#{params[:search]}"/></p>
#{hidden_params}
</form>
<p style="margin: -10px 0px 10px 0px;"><small>Searching by #{Typus::Configuration.config[@model.name]['search'].split(', ').to_sentence(:skip_last_comma => true, :connector => '&').titleize.downcase}.</small></p>
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
            html << "<li>#{link_to status.capitalize, { :params => params.merge(f[0] => status, :page => nil) }, :class => switch}</li>\n"
          end
          html << "</ul>\n"
        when 'datetime'
          html << "<ul>\n"
          %w( today past_7_days this_month this_year ).each do |timeline|
            switch = (current_request.include? "#{f[0]}=#{timeline}") ? 'on' : 'off'
            html << "<li>#{link_to timeline.titleize, { :params => params.merge(f[0] => timeline, :page => nil) }, :class => switch}</li>\n"
          end
          html << "</ul>\n"
        when 'integer'
          model = f[0].split("_id").first.capitalize.camelize.constantize
          if model.count > 0
            ##
            # Here we have the option of having a selector.
            #
            # TODO
            #
            ##
            # Or having a simple list.
            #
            html << "<ul>\n"
            model.find(:all, :order => model.typus_order_by).each do |item|
              switch = (current_request.include? "#{f[0]}=#{item.id}") ? 'on' : 'off'
              html << "<li>#{link_to item.typus_name, { :params => params.merge(f[0] => item.id, :page => nil) }, :class => switch}</li>\n"
            end
            html << "</ul>\n"
          else
            html << "<p>No available #{model.name.downcase.pluralize}.</p>"
          end
        when 'string'
          values = @model.send(f[0])
          if !values.empty?
            html << "<ul>\n"
            values.each do |item|
              switch = current_request.include?("#{f[0]}=#{item}") ? 'on' : 'off'
              html << "<li>#{link_to item.capitalize, { :params => params.merge(f[0] => item) }, :class => switch }</li>\n"
            end
            html << "</ul>\n"
          else
            html << "<p>No available values.</p>"
          end
        end
      end
    end
    return html
  end

  def display_link_to_previous
    html = <<-HTML
<div id="flash" class="notice">
<p>You're adding a new #{@model.name.downcase} to a model. Do you want to cancel it? <a href=\"#{params[:back_to]}\">Click Here</a></p>
</div>
    HTML
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
        html << %{<option #{"selected" if @item.parent_id == category.id} value="#{category.id}">#{"-" * category.ancestors.size} #{category.name}</option>}
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