module AdminTableHelper

  ##
  # All helpers related to table.
  #

=begin

  def build_form(fields = @item_fields)
    returning(String.new) do |html|
      html << "#{error_messages_for :item, :header_tag => "h3"}"
      html << "<ul>"
      fields.each do |field|
        case field.last
        when "boolean":         html << typus_boolean_field(field.first, field.last)
        when "datetime":        html << typus_datetime_field(field.first, field.last)
        when "date":            html << typus_date_field(field.first, field.last)
        when "text":            html << typus_text_field(field.first, field.last)
        when "file":            html << typus_file_field(field.first, field.last)
        when "password":        html << typus_password_field(field.first, field.last)
        when "selector":        html << typus_selector_field(field.first, field.last)
        when "collection":      html << typus_collection_field(field.first, field.last)
        when "tree":            html << typus_tree_field(field.first, field.last)
        else
          html << typus_string_field(field.first, field.last)
        end
      end
      html << "</ul>"
    end
  end

=end

  def build_table(model = @model, fields = 'list', items = @items)

    returning(String.new) do |html|

      html << "<table>"

      ##
      # Header of the table
      #
      html << "<tr>"
      model.typus_fields_for(fields).map(&:first).each do |field|
        order_by = field
        sort_order = (params[:sort_order] == "asc") ? "desc" : "asc"
        if model.model_fields.map(&:first).include?(field)
          html << "<th>#{link_to "<div class=\"#{sort_order}\">#{field.titleize.capitalize}</div>", { :params => params.merge( :order_by => order_by, :sort_order => sort_order) }}</th>"
        else
          html << "<th>#{field.titleize.capitalize}</th>"
        end
      end
      html << "<th>&nbsp;</th>\n</tr>"

      items.each do |item|

        html << "<tr class=\"#{cycle('even', 'odd')}\" id=\"item_#{item.id}\">"

        model.typus_fields_for(fields).each do |column|
          case column[1]
          when "boolean":           html << typus_table_boolean_field(item, column)
          when "datetime", "date"
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

  def typus_table_boolean_field(item, column)

    image = "#{image_tag(status = item.send(column[0])? "admin/status_true.gif" : "admin/status_false.gif")}"

    returning(String.new) do |html|

      if Typus::Configuration.options[:toggle]
        html << <<-HTML
<td width="20px" align="center">
  #{link_to image, {:params => params.merge(:controller => "admin/#{item.class.modelize}", :action => 'toggle', :field => column[0], :id => item.id)} , :confirm => "Change #{column[0]}?"}
</td>
        HTML
        #{link_to image, {:params => params.merge(:controller => "admin/#{model.name.tableize}", :action => 'toggle', :field => column[0], :id => item.id)} , :confirm => "Change #{column[0]}?"}
      else
        html << <<-HTML
<td width="20px" align="center">#{image}</td>
        HTML
      end

    end

  end

end