module AdminTableHelper

  ##
  # All helpers related to table.
  #

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
            html << "<td>#{link_to item.send(column[0].split("_id").first).typus_name, :controller => "admin/#{column[0].split("_id").first.pluralize}", :action => "edit", :id => item.send(column[0])}</td>"
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
            html << "<td>#{link_to item.send(column[0]) || "", :controller => "admin/#{model.name.tableize}", :action => 'edit', :id => item.id}"
            html << "<br /><small>#{"Custom actions go here, but only if exist." if Typus::Configuration.options[:actions_on_table]}</small></td>"
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

      if @current_user.can_perform?(model, 'delete')

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

end