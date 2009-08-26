module Admin::TableHelper

  def build_typus_table(model, fields, items, link_options = {}, association = nil)

    returning(String.new) do |html|

      html << <<-HTML
<table class="typus">
      HTML

      html << typus_table_header(model, fields)

      items.each do |item|

        html << <<-HTML
<tr class="#{cycle('even', 'odd')}" id="item_#{item.id}">
        HTML

        fields.each do |key, value|
          case value
          when :boolean then           html << typus_table_boolean_field(key, item)
          when :datetime then          html << typus_table_datetime_field(key, item, link_options)
          when :date then              html << typus_table_datetime_field(key, item, link_options)
          when :file then              html << typus_table_file_field(key, item, link_options)
          when :time then              html << typus_table_datetime_field(key, item, link_options)
          when :belongs_to then        html << typus_table_belongs_to_field(key, item)
          when :tree then              html << typus_table_tree_field(key, item)
          when :position then          html << typus_table_position_field(key, item)
          when :has_and_belongs_to_many then
            html << typus_table_has_and_belongs_to_many_field(key, item)
          else
            html << typus_table_string_field(key, item, link_options)
          end

        end

      action = item.class.typus_options_for(:default_action_on_item)
      content = link_to _(action.capitalize), :controller => "admin/#{item.class.name.tableize}", :action => action, :id => item.id
      html << <<-HTML
<td width="10px">#{content}</td>
      HTML

      ##
      # This controls the action to perform. If we are on a model list we 
      # will remove the entry, but if we inside a model we will remove the 
      # relationship between the models.
      #
      # Only shown is the user can destroy items.
      #
      if @current_user.can_perform?(model, 'delete')

        trash = "<div class=\"sprite trash\">Trash</div>"

        case params[:action]
        when 'index'
          perform = link_to trash, { :action => 'destroy', 
                                     :id => item.id }, 
                                     :confirm => _("Remove entry?"), 
                                     :method => :delete
        else
          perform = link_to trash, { :action => 'unrelate', 
                                     :id => params[:id], 
                                     :association => association, 
                                     :resource => model, 
                                     :resource_id => item.id }, 
                                     :confirm => _("Unrelate {{unrelate_model}} from {{unrelate_model_from}}?", 
                                     :unrelate_model => model.typus_human_name, 
                                     :unrelate_model_from => @resource[:class].typus_human_name)
        end

        html << <<-HTML
<td width="10px">#{perform}</td>
        HTML

      end

      html << <<-HTML
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
      fields.each do |key, value|

        content = model.human_attribute_name(key)
        content += " (#{key})" if key.include?('_id')

        if (model.model_fields.map(&:first).collect { |i| i.to_s }.include?(key) || model.reflect_on_all_associations(:belongs_to).map(&:name).include?(key.to_sym)) && params[:action] == 'index'
          sort_order = case params[:sort_order]
                       when 'asc'   then  ['desc', '&darr;']
                       when 'desc'  then  ['asc', '&uarr;']
                       else
                         [nil, nil]
                       end
          order_by = model.reflect_on_association(key.to_sym).primary_key_name rescue key
          switch = (params[:order_by] == key) ? sort_order.last : ''
          options = { :order_by => order_by, :sort_order => sort_order.first }
          content = (link_to "#{content} #{switch}", params.merge(options))
        end

        headers << "<th>#{content}</th>"

      end
      headers << "<th>&nbsp;</th>" if @current_user.can_perform?(model, 'delete')
      html << <<-HTML
<tr>
#{headers.join("\n")}
</tr>
      HTML
    end
  end

  def typus_table_belongs_to_field(attribute, item)

    action = item.send(attribute).class.typus_options_for(:default_action_on_item) rescue 'edit'

    content = if !item.send(attribute).kind_of?(NilClass)
                link_to item.send(attribute).typus_name, :controller => "admin/#{attribute.pluralize}", :action => action, :id => item.send(attribute).id
              end

    <<-HTML
<td>#{content}</td>
    HTML

  end

  def typus_table_has_and_belongs_to_many_field(attribute, item)
    <<-HTML
<td>#{item.send(attribute).map { |i| i.typus_name }.join('<br />')}</td>
    HTML
  end

  def typus_table_string_field(attribute, item, link_options = {})
    <<-HTML
<td>#{item.send(attribute)}</td>
    HTML
  end

  def typus_table_file_field(attribute, item, link_options = {})
    <<-HTML
<td><a href="##{item.to_dom(:suffix => 'zoom')}" id="#{item.to_dom}" title="Click to preview">#{item.send(attribute)}</a></td>
<div id="#{item.to_dom(:suffix => 'zoom')}">#{item.typus_preview}</div>
    HTML
  end

  def typus_table_tree_field(attribute, item)
    <<-HTML
<td>#{item.parent.typus_name if item.parent}</td>
    HTML
  end

  def typus_table_position_field(attribute, item)

    html_position = []

    [['Up', 'move_higher'], ['Down', 'move_lower']].each do |position|

      options = { :controller => item.class.name.tableize, 
                  :action => 'position', 
                  :id => item.id, 
                  :go => position.last }

      first_or_last = (item.respond_to?(:first?) && (position.last == 'move_higher' && item.first?)) || (item.respond_to?(:last?) && (position.last == 'move_lower' && item.last?))
      html_position << link_to_unless(first_or_last, _(position.first), params.merge(options)) do |name|
        %(<span class="inactive">#{name}</span>)
      end
    end

    <<-HTML
<td>#{html_position.join(' / ')}</td>
    HTML

  end

  def typus_table_datetime_field(attribute, item, link_options = {} )

    date_format = item.class.typus_date_format(attribute)
    content = !item.send(attribute).nil? ? item.send(attribute).to_s(date_format) : item.class.typus_options_for(:nil)

    <<-HTML
<td>#{content}</td>
    HTML

  end

  def typus_table_boolean_field(attribute, item)

    boolean_hash = item.class.typus_boolean(attribute)
    status = item.send(attribute)
    link_text = !item.send(attribute).nil? ? boolean_hash["#{status}".to_sym] : item.class.typus_options_for(:nil)

    options = { :controller => item.class.name.tableize, :action => 'toggle', :field => attribute.gsub(/\?$/,''), :id => item.id }

    content = if item.class.typus_options_for(:toggle) && !item.send(attribute).nil?
                link_to link_text, params.merge(options), 
                                   :confirm => _("Change {{attribute}}?", 
                                   :attribute => item.class.human_attribute_name(attribute).downcase)
              else
                link_text
              end

    <<-HTML
<td align="center">#{content}</td>
    HTML

  end

end