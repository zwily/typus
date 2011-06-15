module Admin::Resources::FormHelper

  def build_form(fields, form)
    String.new.tap do |html|
      fields.each do |key, value|
        value = :template if (template = @resource.typus_template(key))
        html << case value
                when :belongs_to
                  typus_belongs_to_field(key, form)
                when :tree
                  typus_tree_field(key, form)
                when :boolean, :date, :datetime, :text, :time, :password, :selector, :dragonfly, :paperclip
                  typus_template_field(key, value, form)
                when :template
                  typus_template_field(key, template, form)
                else
                  typus_template_field(key, :string, form)
                end
      end
    end.html_safe
  end

  def typus_template_field(attribute, template, form)
    options = { :start_year => @resource.typus_options_for(:start_year),
                :end_year => @resource.typus_options_for(:end_year),
                :minute_step => @resource.typus_options_for(:minute_step),
                :disabled => attribute_disabled?(attribute),
                :include_blank => true }

    html_options = attribute_disabled?(attribute) ? { :disabled => 'disabled' } : {}

    locals = { :resource => @resource,
               :attribute => attribute,
               :options => options,
               :html_options => html_options,
               :form => form,
               :label_text => @resource.human_attribute_name(attribute) }

    render "admin/templates/#{template}", locals
  end

  def attribute_disabled?(attribute)
    role = admin_user.is_root? ? :admin : :default
    @resource._protected_attributes[role].include?(attribute)
  end

  def display_errors
    render "helpers/admin/resources/errors"
  end

  def save_options
    if Typus.user_class == @resource && admin_user.is_not_root?
      options = { "_continue" => "Save and continue editing" }
    end

    if params[:layout] == 'admin/headless' && params[:resource]
      options = { "_saveandassign" => "Save and assign" }
    end

    if params[:layout] == 'admin/headless'
      options = { "_continue" => "Save and continue editing" }
    end

    options || { "_addanother" => "Save and add another", "_continue" => "Save and continue editing", "_save" => "Save" }
  end

end
