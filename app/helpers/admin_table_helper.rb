module AdminTableHelper

  ##
  # All helpers related to table.
  #
  def build_table(model = @resource[:class], fields = 'list', items = @items)

    returning(String.new) do |html|

      html << "<table>"

      html << typus_table_header(model, fields)

      items.each do |item|

        html << "<tr class=\"#{cycle('even', 'odd')}\" id=\"item_#{item.id}\">"

        model.typus_fields_for(fields).each do |column|
          case column[1]
          when "boolean":           html << typus_table_boolean_field(item, column)
          when "datetime", "date":  html << typus_table_datetime_field(item, column)
          when "time":              html << typus_table_time_field(item, column)
          when "collection":        html << typus_table_collection_field(item, column)
          when "tree":              html << typus_table_tree_field(item, column)
          when "position":          html << typus_table_position_field(item, column)
          else
            html << typus_table_string_field(item, column, fields)
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
          perform = link_to image_tag("admin/trash.gif"), { :controller => "admin/#{model.name.tableize}", 
                                                            :action => 'destroy', 
                                                            :id => item.id }, 
                                                            :confirm => "Remove entry?", 
                                                            :method => :delete
        else
          perform = link_to image_tag("admin/trash.gif"), { :controller => "admin/#{model.name.tableize}", 
                                                            :action => "unrelate", 
                                                            :id => item.id, 
                                                            :model => @resource[:class], 
                                                            :model_id => params[:id] }, 
                                                            :confirm => "Unrelate #{model.humanize.singularize} from #{@resource[:class_name]}?"
        end

      end

      html << "<td width=\"10px\">#{perform}</td>\n</tr>"

    end

      html << "</table>"

    end

  end

  ##
  # Header of the table
  #
  def typus_table_header(model, fields)
    returning(String.new) do |html|
      html << "<tr>"
      model.typus_fields_for(fields).map(&:first).each do |field|
        order_by = model.reflect_on_association(field.to_sym).primary_key_name rescue field
        sort_order = (params[:sort_order] == 'asc') ? 'desc' : 'asc'
        if (model.model_fields.map(&:first).include?(field) || model.reflect_on_all_associations.map(&:name).include?(field.to_sym)) && params[:action] == 'index'
          html << "<th>#{link_to "<div class=\"#{sort_order}\">#{field.titleize.capitalize}</div>", { :params => params.merge(:order_by => order_by, :sort_order => sort_order) }}</th>"
        else
          html << "<th>#{field.titleize.capitalize}</th>"
        end
      end
      html << "<th>&nbsp;</th>\n</tr>"
    end
  end

  def typus_table_collection_field(item, column)
    if item.send(column[0]).kind_of?(Array)
      "<td>#{item.send(column[0]).map(&:typus_name).join(', ')}</td>"
    elsif item.send(column[0]).kind_of?(NilClass)
      "<td></td>"
    else
      "<td>#{link_to item.send(column[0]).typus_name, :controller => "admin/#{column[0].pluralize}", :action => "edit", :id => item.send(column[0])}</td>"
    end
  end

  ##
  # When detection of the attributes is made a default attribute 
  # type is set. From the string_field we display other content 
  # types.
  #
  def typus_table_string_field(item, column, fields)
    returning(String.new) do |html|
      if item.class.typus_fields_for(fields).first == column
        html << <<-HTML
<td>#{link_to item.send(column[0]) || "", :controller => "admin/#{item.class.name.tableize}", :action => 'edit', :id => item.id}
<br /><small>#{"Custom actions go here, but only if exist." if Typus::Configuration.options[:actions_on_table]}</small></td>
        HTML
      else
        if item.send(column[0]).kind_of?(Array)
          html << <<-HTML
<td>#{item.send(column[0]).map { |i| i.typus_name }.join(', ')}</td>
          HTML
        else
          html << <<-HTML
<td>#{item.send(column[0])}</td>
          HTML
        end
      end
    end
  end

  def typus_table_tree_field(item, column)
    returning(String.new) do |html|
      html << <<-HTML
<td>#{item.parent.typus_name if item.parent}</td>
      HTML
    end
  end

  def typus_table_position_field(item, column)
    returning(String.new) do |html|
      html_position = []
      [["Up", "move_higher"], ["Down", "move_lower"]].each do |position|
        html_position << <<-HTML
#{link_to position.first, :params => params.merge(:controller => "admin/#{item.class.name.tableize}", :action => 'position', :id => item.id, :go => position.last)}
        HTML
      end
      html << <<-HTML
<td>#{html_position.join('/ ')}</td>
      HTML
    end
  end

  def typus_table_datetime_field(item, column)
    returning(String.new) do |html|
      html << <<-HTML
<td>#{!item.send(column[0]).nil? ? item.send(column[0]).to_s(:db) : 'nil'}</td>
      HTML
    end
  end

  def typus_table_time_field(item, column)
    returning(String.new) do |html|
      html << <<-HTML
<td>#{item.send(column[0])}</td>
      HTML
    end
  end

  def typus_table_boolean_field(item, column)

    boolean_icon = Typus::Configuration.options[:icon_on_boolean]
    boolean_hash = @resource[:class].typus_boolean(column.first)

    unless item.send(column[0]).nil?
      status = item.send(column[0])
      content = (boolean_icon) ? image_tag("admin/status_#{status}.gif") : boolean_hash["#{status}".to_sym]
    else
      # If the column is null we show the false icon.
      content = (boolean_icon) ? image_tag("admin/status_false.gif") : boolean_hash[:false]
    end

    returning(String.new) do |html|

      if Typus::Configuration.options[:toggle]
        html << <<-HTML
<td align="center">
  #{link_to content, {:params => params.merge(:controller => "admin/#{item.class.name.tableize}", :action => 'toggle', :field => column[0], :id => item.id)} , :confirm => "Change #{column[0]}?"}
</td>
        HTML
      else
        html << <<-HTML
<td align="center">#{content}</td>
        HTML
      end

    end

  end

end