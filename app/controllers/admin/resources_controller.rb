require "typus/format"

class Admin::ResourcesController < AdminController

  include Typus::Format

  before_filter :detect_resource

  before_filter :get_resource, 
                :only => [ :show, 
                           :edit, :update, :destroy, :toggle, 
                           :position, :relate, :unrelate, 
                           :detach ]

  before_filter :check_resource_ownership, 
                :only => [ :edit, :update, :destroy, :toggle, 
                           :position, :relate, :unrelate ]

  before_filter :check_if_user_can_perform_action_on_user, 
                :only => [ :edit, :update, :toggle, :destroy ]
  before_filter :check_if_user_can_perform_action_on_resources

  before_filter :set_order, 
                :only => [ :index ]
  before_filter :set_fields, 
                :only => [ :index, :new, :edit, :create, :update, :show ]

  ##
  # This is the main index of the model. With filters, conditions 
  # and more.
  #
  # By default application can respond_to html, csv and xml, but you 
  # can add your formats.
  #
  def index

    @conditions, @joins = @resource[:class].build_conditions(params)

    check_resource_ownerships if @resource[:class].typus_options_for(:only_user_items)

    respond_to do |format|
      format.html do
        generate_html
        select_template :index
      end
      @resource[:class].typus_export_formats.each do |f|
        format.send(f) { send("generate_#{f}") }
      end
    end

  end

  def new

    check_ownership_of_referal_item

    item_params = params.dup
    %w( controller action resource resource_id back_to selected ).each do |param|
      item_params.delete(param)
    end

    @item = @resource[:class].new(item_params.symbolize_keys)

    select_template :new

  end

  ##
  # Create new items. There's an special case when we create an 
  # item from another item. In this case, after the item is 
  # created we also create the relationship between these items. 
  #
  def create

    @item = @resource[:class].new(params[@object_name])

    if @resource[:class].typus_user_id?
      @item.attributes = { Typus.user_fk => @current_user.id }
    end

    if @item.valid?

      create_with_back_to and return if params[:back_to]
      @item.save

      action = @resource[:class].typus_options_for(:action_after_save)
      path = { :action => action }
      path.merge!(:id => @item.id) unless action.eql?("index")
      notice = _("{{model}} successfully created.", :model => @resource[:human_name])

      redirect_to path, :notice => notice

    else
      select_template :new
    end

  end

  def edit

    item_params = params.dup
    %w( action controller model model_id back_to id resource resource_id page ).each { |p| item_params.delete(p) }

    # We assign the params passed trough the url
    @item.attributes = item_params

    item_params.merge!(set_conditions)
    @previous, @next = @item.previous_and_next(item_params)

    select_template :edit

  end

  def show

    check_resource_ownership and return if @resource[:class].typus_options_for(:only_user_items)

    @previous, @next = @item.previous_and_next(set_conditions)

    respond_to do |format|
      format.html { select_template :show }
      # TODO: Responders for multiple file formats. For example PDF ...
      format.xml do
        fields = @resource[:class].typus_fields_for(:xml).collect { |i| i.first }
        render :xml => @item.to_xml(:only => fields)
      end
    end

  end

  def update

    if @item.update_attributes(params[@object_name])

      if @resource[:class].typus_user_id? && @current_user.is_not_root?
        @item.update_attributes Typus.user_fk => @current_user.id
      end

      action = @resource[:class].typus_options_for(:action_after_save)

      path = case action
             when "index"
               params[:back_to] ? "#{params[:back_to]}##{@resource[:self]}" : { :action => action }
             else
               { :action => action, 
                 :id => @item.id, 
                 :back_to => params[:back_to] }
             end
      notice = _("{{model}} successfully updated.", :model => @resource[:human_name])

      # Reload @current_user when updating to see flash message in the 
      # correct locale.
      if @resource[:class].eql?(Typus.user_class)
        I18n.locale = @current_user.reload.preferences[:locale]
        @resource[:human_name] = params[:controller].extract_human_name
      end

      redirect_to path, :notice => notice

    else

      @previous, @next = @item.previous_and_next
      select_template :edit

    end

  end

  def destroy
    @item.destroy

    path = request.referer || admin_dashboard_path
    notice = _("{{model}} successfully removed.", :model => @resource[:human_name])

    redirect_to path, :notice => notice
  end

  def toggle
    @item.toggle(params[:field])
    @item.save!

    path = request.referer || admin_dashboard_path
    notice = _("{{model}} {{attribute}} changed.", 
               :model => @resource[:human_name], 
               :attribute => params[:field].humanize.downcase)

    redirect_to path, :notice => notice
  end

  ##
  # Change item position. This only works if acts_as_list is 
  # installed. We can then move items:
  #
  #   params[:go] = 'move_to_top'
  #
  # Available positions are move_to_top, move_higher, move_lower, 
  # move_to_bottom.
  #
  def position
    @item.send(params[:go])

    path = request.referer || admin_dashboard_path
    notice = _("Record moved {{to}}.", :to => params[:go].gsub(/move_/, '').humanize.downcase)

    redirect_to path, :notice => notice
  end

  ##
  # Relate a model object to another, this action is used only by the 
  # has_and_belongs_to_many and has_many relationships.
  #
  def relate

    resource_class = params[:related][:model].constantize
    resource_tableized = params[:related][:model].tableize

    if @item.send(resource_tableized) << resource_class.find(params[:related][:id])
      flash[:notice] = _("{{model_a}} related to {{model_b}}.", 
                         :model_a => resource_class.model_name.human, 
                         :model_b => @resource[:human_name])
    else
      # TODO: Show the reason why cannot be related showing model_a and model_b errors.
      flash[:alert] = _("{{model_a}} cannot be related to {{model_b}}.", 
                         :model_a => resource_class.model_name.human, 
                         :model_b => @resource[:human_name])
    end

    redirect_to :back

  end

  ##
  # Remove relationship between models, this action never removes items!
  #
  def unrelate

    resource_class = params[:resource].classify.constantize
    resource_tableized = params[:resource].tableize
    resource = resource_class.find(params[:resource_id])

    if @resource[:class].
       reflect_on_association(resource_class.table_name.singularize.to_sym).
       try(:macro) == :has_one
      attribute = resource_tableized.singularize
      saved_succesfully = @item.update_attribute attribute, nil
    else
      attribute = resource_tableized
      saved_succesfully = @item.send(attribute).delete(resource)
    end

    if saved_succesfully
      flash[:notice] = _("{{model_a}} unrelated from {{model_b}}.", 
                         :model_a => resource_class.model_name.human, 
                         :model_b => @resource[:human_name])
    else
      # TODO: Show the reason why cannot be unrelated showing model_a and model_b errors.
      flash[:alert] = _("{{model_a}} cannot be unrelated to {{model_b}}.", 
                        :model_a => resource_class.model_name.human, 
                        :model_b => @resource[:human_name])
    end

    redirect_to :back

  end

  ##
  # Remove file attachments.
  #
  def detach
    attachment = @resource[:class].human_attribute_name(params[:attachment])

    message = if @item.update_attributes(params[:attachment] => nil)
                "{{attachment}} removed."
              else
                "{{attachment}} can't be removed."
              end
    notice = _(message, :attachment => attachment)

    redirect_to :back, :notice => notice
  end

private

  def detect_resource
    @resource = { :self => params[:controller].extract_resource, 
                  :human_name => params[:controller].extract_human_name, 
                  :class => params[:controller].extract_class }
    @object_name = ActionController::RecordIdentifier.singular_class_name(@resource[:class])
  end

  ##
  # Find model when performing an edit, update, destroy, relate, 
  # unrelate ...
  #
  def get_resource
    @item = @resource[:class].find(params[:id])
  end

  def set_fields

    mapping = case params[:action]
              when 'index' then :list
              when 'new', 'edit', 'create', 'update' then :form
              else params[:action]
              end

    @fields = @resource[:class].typus_fields_for(mapping)

  end

  def set_order
    params[:sort_order] ||= 'desc'
    @order = params[:order_by] ? "#{@resource[:class].table_name}.#{params[:order_by]} #{params[:sort_order]}" : @resource[:class].typus_order_by
  end

  ##
  # When <tt>params[:back_to]</tt> is defined this action is used.
  #
  # - <tt>has_and_belongs_to_many</tt> relationships.
  # - <tt>has_many</tt> relationships (polymorphic ones).
  #
  def create_with_back_to

    if params[:resource] && params[:resource_id]
      resource_class = params[:resource].classify.constantize
      resource_id = params[:resource_id]
      resource = resource_class.find(resource_id)
      association = @resource[:class].reflect_on_association(params[:resource].to_sym).macro rescue :polymorphic
    else
      association = :has_many
    end

    case association
    when :belongs_to
      @item.save
    when :has_and_belongs_to_many
      @item.save
      @item.send(params[:resource]) << resource
    when :has_many
      @item.save
      message = _("{{model}} successfully created.", 
                  :model => @resource[:human_name])
      path = "#{params[:back_to]}?#{params[:selected]}=#{@item.id}"
    when :polymorphic
      resource.send(@item.class.name.tableize).create(params[@object_name])
    end

    flash[:notice] = message || _("{{model_a}} successfully assigned to {{model_b}}.", 
                                  :model_a => @item.class.model_name.human, 
                                  :model_b => resource_class.model_name.human)

    redirect_to path || params[:back_to]

  end

  def select_template(template, resource = @resource[:self])
    folder = (File.exist?("app/views/admin/#{resource}/#{template}.html.erb")) ? resource : 'resources'
    render "admin/#{folder}/#{template}"
  end

end