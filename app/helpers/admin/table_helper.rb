module Admin

  module TableHelper

    def build_typus_table(model, fields, items, link_options = {}, association = nil)
      render "admin/helpers/table/table", 
             :model => model, 
             :fields => fields, 
             :items => items, 
             :link_options => link_options,
             :headers => typus_table_header(model, fields)
    end

    def typus_table_header(model, fields)

      headers = fields.map do |key, value|

                  key = key.gsub(".", " ") if key.match(/\./)
                  content = key.end_with?('_id') ? key : model.human_attribute_name(key)

                  if (model.model_fields.map(&:first).collect { |i| i.to_s }.include?(key) || model.reflect_on_all_associations(:belongs_to).map(&:name).include?(key.to_sym)) && params[:action] == 'index'
                    sort_order = case params[:sort_order]
                                 when 'asc'   then ['desc', '&darr;']
                                 when 'desc'  then ['asc', '&uarr;']
                                 else
                                   [nil, nil]
                                 end
                    order_by = model.reflect_on_association(key.to_sym).primary_key_name rescue key
                    switch = sort_order.last if params[:order_by].eql?(order_by)
                    options = { :order_by => order_by, :sort_order => sort_order.first }
                    content = link_to raw("#{content} #{switch}"), params.merge(options)
                  end

                  content

                end

      return headers

    end

    def typus_table_fields_for_item(item, fields, link_options)
      content = String.new

      fields.each do |key, value|
        content << case value
                   when :boolean then typus_table_boolean_field(key, item)
                   when :datetime then typus_table_datetime_field(key, item, link_options)
                   when :date then typus_table_datetime_field(key, item, link_options)
                   when :file then typus_table_file_field(key, item, link_options)
                   when :time then typus_table_datetime_field(key, item, link_options)
                   when :belongs_to then typus_table_belongs_to_field(key, item)
                   when :tree then typus_table_tree_field(key, item)
                   when :position then typus_table_position_field(key, item)
                   when :selector then typus_table_selector(key, item)
                   when :transversal then typus_table_transversal(key, item)
                   when :has_and_belongs_to_many then typus_table_has_and_belongs_to_many_field(key, item)
                   else
                     typus_table_string_field(key, item, link_options)
                   end
      end

      return raw(content)
    end

    def typus_table_default_action(model, item)
      action = if model.typus_user_id? && @current_user.is_not_root?
                 # If there's a typus_user_id column on the table and logged user is not root ...
                 item.owned_by?(@current_user) ? item.class.typus_options_for(:default_action_on_item) : 'show'
               elsif @current_user.cannot?('edit', model)
                 'show'
               else
                 item.class.typus_options_for(:default_action_on_item)
               end

      options = { :controller => "admin/#{item.class.to_resource}", 
                  :action => action, 
                  :id => item.id }

      link_to _(action.capitalize), options
    end

    ##
    # This controls the action to perform. If we are on a model list we 
    # will remove the entry, but if we inside a model we will remove the 
    # relationship between the models.
    #
    # Only shown is the user can destroy/unrelate items.
    #
    def typus_table_action(model, item)

      condition = true

      case params[:action]
      when "index"
        action = "trash"
        options = { :action => 'destroy', :id => item.id }
      when "edit", "show"
        action = "unrelate"
        options = { :action => 'unrelate', :id => params[:id], :resource => model, :resource_id => item.id }
      end

      title = _(action.titleize)

      case params[:action]
      when 'index'
        condition = if model.typus_user_id? && @current_user.is_not_root?
                      item.owned_by?(@current_user)
                    else
                      @current_user.can?('destroy', model)
                    end
        confirm = _("Remove entry?")
      when 'edit'
        # If we are editing content, we can relate and unrelate always!
        confirm = _("Unrelate {{unrelate_model}} from {{unrelate_model_from}}?", 
                    :unrelate_model => model.model_name.human, 
                    :unrelate_model_from => @resource[:human_name])
      when 'show'
        # If we are showing content, we only can relate and unrelate if we are 
        # the owners of the owner record.
        # If the owner record doesn't have a foreign key (Typus.user_fk) we look
        # each item to verify the ownership.
        condition = if @resource[:class].typus_user_id? && @current_user.is_not_root?
                      @item.owned_by?(@current_user)
                    end
        confirm = _("Unrelate {{unrelate_model}} from {{unrelate_model_from}}?", 
                    :unrelate_model => model.model_name.human, 
                    :unrelate_model_from => @resource[:human_name])
      end

      message = %(<div class="sprite #{action}">#{action.titleize}</div>)

      if condition
        link_to raw(message), options, :title => title, :confirm => confirm
      end

    end

    def typus_table_belongs_to_field(attribute, item)

      action = item.send(attribute).class.typus_options_for(:default_action_on_item)

      att_value = item.send(attribute)
      content = if !att_value.nil?
        if @current_user.can?(action, att_value.class.name)
          link_to item.send(attribute).to_label, :controller => "admin/#{att_value.class.to_resource}", :action => action, :id => att_value.id
        else
          att_value.to_label
        end
      end

      return content_tag(:td, content)

    end

    def typus_table_has_and_belongs_to_many_field(attribute, item)
      content = item.send(attribute).map { |i| i.to_label }.join('<br />')
      return content_tag(:td, content)
    end

    def typus_table_string_field(attribute, item, link_options = {})
      content = h(item.send(attribute))
      return content_tag(:td, raw(!content.empty? ? content : "&#151;"), :class => attribute)
    end

    def typus_table_selector(attribute, item)
      content = h(item.mapping(attribute))
      return content_tag(:td, content, :class => attribute)
    end

    def typus_table_file_field(attribute, item, link_options = {})

      attachment = attribute.split("_file_name").first
      file_preview = Typus.file_preview
      file_thumbnail = Typus.file_thumbnail

      has_file_preview = item.send(attachment).styles.member?(file_preview)
      file_preview_is_image = item.send("#{attachment}_content_type") =~ /^image\/.+/

      content = if has_file_preview && file_preview_is_image
                  render "admin/helpers/preview", 
                         :attribute => attribute, 
                         :attachment => attachment, 
                         :content => item.send(attribute), 
                         :has_file_preview => has_file_preview, 
                         :href => item.send(attachment).url(file_preview), 
                         :item => item
                else
                  link_to item.send(attribute), item.send(attachment).url
                end

      return content_tag(:td, content)

    end

    def typus_table_tree_field(attribute, item)
      content = item.parent ? item.parent.to_label : "&#151;"
      return content_tag(:td, content)
    end

    # OPTIMIZE: Move html code to partial.
    def typus_table_position_field(attribute, item)

      html_position = []

      [['Up', 'move_higher'], ['Down', 'move_lower']].each do |position|

        options = { :controller => item.class.to_resource, 
                    :action => 'position', 
                    :id => item.id, 
                    :go => position.last }

        first_or_last = (item.respond_to?(:first?) && (position.last == 'move_higher' && item.first?)) || (item.respond_to?(:last?) && (position.last == 'move_lower' && item.last?))
        html_position << link_to_unless(first_or_last, _(position.first), params.merge(options)) do |name|
          %(<span class="inactive">#{name}</span>)
        end
      end

      content = html_position.join(' / ')
      return content_tag(:td, content)

    end

    def typus_table_datetime_field(attribute, item, link_options = {} )

      date_format = item.class.typus_date_format(attribute)
      content = !item.send(attribute).nil? ? item.send(attribute).to_s(date_format) : item.class.typus_options_for(:nil)

      return content_tag(:td, content)

    end

    def typus_table_boolean_field(attribute, item)
      boolean_hash = item.class.typus_boolean(attribute)
      status = item.send(attribute)

      content = if status.nil?
                  Typus::Resource.nil
                else
                  message = _(boolean_hash["#{status}".to_sym])
                  options = { :controller => "admin/#{item.class.to_resource}", 
                              :action => 'toggle', 
                              :id => item.id, 
                              :field => attribute.gsub(/\?$/,'') }
                  confirm = _("Change {{attribute}}?", 
                              :attribute => item.class.human_attribute_name(attribute).downcase)
                  link_to message, options, :confirm => confirm
                end

      return content_tag(:td, content)
    end

    def typus_table_transversal(attribute, item)
      _attribute, virtual = attribute.split(".")
      return content_tag(:td, "#{item.send(_attribute).send(virtual)}")
    end

  end

end
