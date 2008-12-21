module AdminTableHelper

  ##
  # All helpers related to table.
  #
  def build_table(model = @resource[:class], fields = 'list', items = @items)

    returning(String.new) do |html|

      html << <<-HTML
<table>
      HTML

      html << typus_table_header(model, fields)

      items.each do |item|

        html << <<-HTML
<tr class="#{cycle('even', 'odd')}" id="item_#{item.id}">
        HTML

        model.typus_fields_for(fields).each do |column|
          case column[1]
          when :boolean:           html << typus_table_boolean_field(item, column)
          when :datetime:          html << typus_table_datetime_field(item, column)
          when :date:              html << typus_table_datetime_field(item, column)
          when :time:              html << typus_table_datetime_field(item, column)
          when :belongs_to:        html << typus_table_belongs_to_field(item, column)
          when :tree:              html << typus_table_tree_field(item, column)
          when :position:          html << typus_table_position_field(item, column)
          when :has_and_belongs_to_many:
            html << typus_table_has_and_belongs_to_many_field(item, column)
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
          perform = link_to image_tag("admin/trash.gif"), { :action => "unrelate", 
                                                            :id => params[:id], 
                                                            :resource => item.class.name.tableize, 
                                                            :resource_id => item.id }, 
                                                            :confirm => "Unrelate #{model.humanize.singularize} from #{@resource[:class_name]}?"
        end

      end

      html << <<-HTML
<td width="10px">#{perform}</td>
</tr>
      HTML

    end

      html << "</table>"

    end

  end

  ##
  # Header of the table
  #
  def typus_table_header(model, fields)
    returning(String.new) do |html|
      headers = []
      model.typus_fields_for(fields).map(&:first).each do |field|
        order_by = model.reflect_on_association(field.to_sym).primary_key_name rescue field
        sort_order = (params[:sort_order] == 'asc') ? 'desc' : 'asc'
        if (model.model_fields.map(&:first).include?(field) || model.reflect_on_all_associations(:belongs_to).map(&:name).include?(field.to_sym)) && params[:action] == 'index'
          headers << "<th>#{link_to "<div class=\"#{sort_order}\">#{field.titleize.capitalize}</div>", { :params => params.merge(:order_by => order_by, :sort_order => sort_order) }}</th>"
        else
          headers << "<th>#{field.titleize.capitalize}</th>"
        end
      end
      headers << "<th>&nbsp;</th>"
      html << <<-HTML
<tr>
#{headers.join("\n")}
</tr>
      HTML
    end
  end

  def typus_table_belongs_to_field(item, column)
    if item.send(column[0]).kind_of?(NilClass)
      "<td></td>"
    else
      "<td>#{link_to item.send(column[0]).typus_name, :controller => column[0].pluralize, :action => "edit", :id => item.send(column[0])}</td>"
    end
  end

  def typus_table_has_and_belongs_to_many_field(item, column)
    returning(String.new) do |html|
      html << <<-HTML
<td>#{item.send(column[0]).map { |i| i.typus_name }.join('<br />')}</td>
      HTML
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
<td>#{link_to item.send(column[0]) || Typus::Configuration.options[:nil], :controller => "admin/#{item.class.name.tableize}", :action => 'edit', :id => item.id}
<br /><small>#{"Custom actions go here, but only if exist." if Typus::Configuration.options[:actions_on_table]}</small></td>
        HTML
      else
        html << <<-HTML
<td>#{item.send(column[0])}</td>
        HTML
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

    date_format = @resource[:class].typus_date_format(column.first)

    returning(String.new) do |html|
      html << <<-HTML
<td>#{!item.send(column[0]).nil? ? item.send(column[0]).to_s(date_format) : Typus::Configuration.options[:nil]}</td>
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
      # If content is nil, we show nil!
      content = Typus::Configuration.options[:nil]
    end

    returning(String.new) do |html|

      if Typus::Configuration.options[:toggle] && !item.send(column[0]).nil?
        html << <<-HTML
<td align="center">
  #{link_to content, {:params => params.merge(:controller => "admin/#{item.class.name.tableize}", :action => 'toggle', :field => column[0], :id => item.id)} , :confirm => "Change #{column[0].humanize.downcase}?"}
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