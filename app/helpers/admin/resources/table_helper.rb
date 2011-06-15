module Admin::Resources::TableHelper

  def build_table(model, fields, items, link_options = {}, association = nil, association_name = nil)
    locals = { :model => model,
               :fields => fields,
               :items => items,
               :link_options => link_options,
               :headers => table_header(model, fields),
               :association_name => association_name }

    render "helpers/admin/resources/table/table", locals
  end

  def table_header(model, fields, params = params)
    fields.map do |key, value|

      key = key.gsub(".", " ") if key.to_s.match(/\./)
      content = model.human_attribute_name(key)

      if params[:action].eql?('index') && model.typus_options_for(:sortable)
        association = model.reflect_on_association(key.to_sym)
        order_by = association ? association.foreign_key : key

        if (model.model_fields.map(&:first).map { |i| i.to_s }.include?(key) || model.reflect_on_all_associations(:belongs_to).map(&:name).include?(key.to_sym))
          sort_order = case params[:sort_order]
                       when 'asc' then ['desc', '&darr;']
                       when 'desc' then ['asc', '&uarr;']
                       else [nil, nil]
                       end
          switch = sort_order.last if params[:order_by].eql?(order_by)
          options = { :order_by => order_by, :sort_order => sort_order.first }
          message = [content, switch].compact.join(" ").html_safe
          link_to message, params.merge(options)
        else
          content
        end

      else
        content
      end

    end
  end

  def table_fields_for_item(item, fields)
    fields.map { |k, v| send("table_#{v}_field", k, item) }
  end

  def resource_actions
    @resource_actions ||= []
  end

  def table_actions(model, item, association_name = nil)
    resource_actions.map do |body, url, options, proc|
      if admin_user.can?(url[:action], model.name)
        next if proc && proc.respond_to?(:call) && proc.call(item) == false

        link_to Typus::I18n.t(body),
                params.dup.cleanup.merge(url).merge(:controller => "/admin/#{model.to_resource}", :id => item.id),
                options
      end
    end.compact.join(" / ").html_safe
  end

end
