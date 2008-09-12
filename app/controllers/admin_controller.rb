class AdminController < ApplicationController

  layout 'typus'

  include Authentication

  before_filter :require_login
  before_filter :current_user

  before_filter :set_model
  before_filter :find_model, :only => [ :show, :edit, :update, :destroy, :toggle, :position ]

  before_filter :check_permissions, :only => [ :index, :new, :create, :edit, :update, :destroy, :toggle ]
  before_filter :check_ownership, :only => [ :destroy ]

  before_filter :can_create?, :only => [ :new, :create ]
  before_filter :can_read?, :only => [ :show ]
  before_filter :can_update?, :only => [ :edit, :update, :position, :toggle ]
  before_filter :can_destroy?, :only => [ :destroy ]

  before_filter :set_order, :only => [ :index ]

  before_filter :fields, :only => [ :index ]
  before_filter :form_fields, :only => [ :new, :edit, :create, :update ]

  ##
  # This is the main index of the model. With the filters, conditions 
  # and more. You can get HTML, CSV and XML listings.
  #
  def index

    ##
    # Build the conditions
    #
    conditions = @model.build_conditions(request.env['QUERY_STRING'] || "")

    ##
    # Pagination
    #
    items_count = @model.count(:conditions => conditions)
    items_per_page = Typus::Configuration.options[:per_page].to_i
    @pager = ::Paginator.new(items_count, items_per_page) do |offset, per_page|
      @model.find(:all, 
                  :conditions => conditions, 
                  :order => @order, 
                  :limit => per_page, 
                  :offset => offset)
    end

    @items = @pager.page(params[:page])

    ##
    # Respond with HTML, CSV and XML versions. This feature is only 
    # available on the index as is where we usually need those file 
    # versions.
    #
    respond_to do |format|
      format.html { select_template :index }
      format.csv { generate_csv }
      format.xml  { render :xml => @items.items }
    end

  rescue Exception => error
    error_handler(error)
  end

  ##
  # New item.
  #
  def new

    item_params = params.dup
    item_params.delete_if { |key, value| key == 'action' }
    item_params.delete_if { |key, value| key == 'controller' }
    item_params.delete_if { |key, value| key == 'model' }
    item_params.delete_if { |key, value| key == 'model_id' }
    item_params.delete_if { |key, value| key == 'back_to' }

    @item = @model.new(item_params.symbolize_keys)

    select_template :new

  end

  ##
  # Create new records. There's an special case when we create a 
  # record from another record. In this case, after the record is 
  # created we create also the relationship between these models. 
  #
  def create
    @item = @model.new(params[:item])
    if @item.save
      if params[:back_to]
        if params[:model] && params[:model_id]
          model_to_relate = params[:model].constantize
          @item.send(params[:model].tableize) << model_to_relate.find(params[:model_id])
          flash[:success] = "#{@item.class} successfully assigned to #{params[:model].downcase}."
        else
          flash[:success] = "New #{@model.to_s.downcase} created."
        end
        redirect_to params[:back_to]
      else
        flash[:success] = "#{@model.to_s.titleize} successfully created."
        redirect_to :action => 'edit', :id => @item.id
      end
    else
      select_template :new
    end
  rescue Exception => error
    error_handler(error, {:params => params.merge(:action => 'index', :id => nil)} )
  end

  ##
  # Edit an item.
  #
  def edit
    @previous, @next = @item.previous, @item.next
    select_template :edit
  end

  ##
  # Show an item.
  #
  def show
    @previous, @next = @item.previous, @item.next
    select_template :show
  end

  ##
  # Update an item.
  #
  def update
    if @item.update_attributes(params[:item])
      flash[:success] = "#{@model.humanize} successfully updated."
      redirect_to :action => 'edit', :id => @item.id
    else
      select_template :edit
    end
  end

  ##
  # Destroy an item.
  #
  def destroy
    @item.destroy
    flash[:success] = "#{@model.humanize} successfully removed."
    redirect_to :back
  rescue Exception => error
    error_handler(error, { :params => params.merge(:action => 'index', :id => nil) })
  end

  ##
  # Toggle the status of an item.
  #
  def toggle
    @item.toggle!(params[:field])
    flash[:success] = "#{@model.humanize} #{params[:field]} changed."
    redirect_to :back
  end

  ##
  # Change item position. This only works if acts_as_list is 
  # installed. We can then move items:
  #
  #   params[:go] = 'move_to_top'
  #   params[:go] = 'move_higher'
  #   params[:go] = 'move_lower'
  #   params[:go] = 'move_to_bottom'
  #
  def position
    @item.send(params[:go])
    flash[:success] = "Record moved #{params[:go].gsub(/move_/, '').humanize.downcase}."
    redirect_to :back
  end

  ##
  # Relate a model object to another.
  #
  def relate
    model_to_relate = params[:related][:model].constantize
    @model.find(params[:id]).send(params[:related][:model].tableize) << model_to_relate.find(params[:related][:id])
    flash[:success] = "#{model_to_relate.to_s.titleize} added to #{@model.humanize.downcase}."
    redirect_to :back
  end

  ##
  # Remove relationship between models.
  #
  def unrelate
    model_to_unrelate = params[:model].constantize
    unrelate = model_to_unrelate.find(params[:model_id])
    @model.find(params[:id]).send(params[:model].tableize).delete(unrelate)
    flash[:success] = "#{model_to_unrelate.to_s.titleize} removed from #{@model.humanize.downcase}."
    redirect_to :back
  end

private

  ##
  # Set current model.
  #
  def set_model
    @model = params[:controller].split("/").last.modelize
  rescue Exception => error
    error_handler(error)
  end

  ##
  # Set default order on the listings.
  #
  def set_order
    unless params[:order_by]
      @order = @model.typus_order_by
    else
      @order = "#{params[:order_by]} #{params[:sort_order]}"
    end
  end

  ##
  # Find
  #
  def find_model
    @item = @model.find(params[:id])
  end

  ##
  # Model +fields+
  #
  def fields
    @fields = @model.typus_fields_for(:list)
  end

  ##
  # Model +form_fields+ and +form_fields_externals+
  #
  def form_fields
    @item_fields = @model.typus_fields_for(:form)
    @item_has_many = @model.typus_relationships_for(:has_many)
    @item_has_and_belongs_to_many = @model.typus_relationships_for(:has_and_belongs_to_many)
  end

  ##
  # Before filter to check if has permission to index, edit, update 
  # & destroy a model.
  #
  def check_permissions
    unless @current_user.models.include? @model.to_s or @current_user.models.include? "All"
      flash[:notice] = "You don't have permission to access this resource."
      redirect_to :back
    end
  rescue
    redirect_to typus_dashboard_url
  end

  ##
  # A TypusUser cannot destroy himself
  #
  def check_ownership
    if @model.to_s == "TypusUser" and @current_user.id == params[:id].to_i
      flash[:notice] = "You cannot remove yourself from Typus."
      redirect_to :back
    end
  end

  ##
  # Select which template to render.
  #
  def select_template(template, model = @model)
    if File.exists?("#{RAILS_ROOT}/app/views/admin/#{model.name.tableize}/#{template}.html.erb")
      render :template => "admin/#{model.name.tableize}/#{template}"
    else
      render :template => "admin/#{template}"
    end
  end

  ##
  # Error handler only active on development.
  #
  def error_handler(error, redirection = typus_dashboard_url)
    unless RAILS_ENV == 'development'
      flash[:error] = error.message.titleize
      redirect_to redirection
    end
  end

  def generate_csv
    fields = @model.typus_fields_for(:csv).collect { |i| i.first }
    csv_string = FasterCSV.generate do |csv|
      csv << fields
      @items.items.each do |item|
        tmp = []
        fields.each { |f| tmp << item.send(f) }
        csv << tmp
      end
    end
    filename = "#{Time.now.strftime("%Y%m%d")}_#{@model.to_s.tableize}.csv"
    send_data(csv_string,
             :type => 'text/csv; charset=utf-8; header=present',
             :filename => filename)
  rescue
    render :text => "FasterCSV is not installed."
  end

end