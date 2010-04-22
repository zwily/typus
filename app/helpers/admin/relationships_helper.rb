module Admin

  module RelationshipsHelper

    # OPTIMIZE: Move html code to partial.
    def typus_form_has_many(field)
      returning(String.new) do |html|

        model_to_relate = @resource.reflect_on_association(field.to_sym).class_name.constantize
        model_to_relate_as_resource = model_to_relate.to_resource

        reflection = @resource.reflect_on_association(field.to_sym)
        association = reflection.macro
        foreign_key = reflection.through_reflection ? reflection.primary_key_name.pluralize : reflection.primary_key_name

        link_options = { :controller => "admin/#{model_to_relate_as_resource.pluralize}", 
                         :action => 'new', 
                         :back_to => "#{@back_to}##{field}", 
                         :resource => @resource.to_resource.singularize, 
                         :resource_id => @item.id, 
                         foreign_key => @item.id }

        condition = if @resource.typus_user_id? && @current_user.is_not_root?
                      @item.owned_by?(@current_user)
                    else
                      true
                    end

        if condition && @current_user.can?('create', model_to_relate)
          add_new = <<-HTML
    <small>#{link_to _("Add new"), link_options}</small>
          HTML
        end

        html << <<-HTML
  <a name="#{field}"></a>
  <div class="box_relationships" id="#{model_to_relate_as_resource}">
    <h2>
    #{link_to model_to_relate.model_name.human.pluralize, { :controller => "admin/#{model_to_relate_as_resource}", foreign_key => @item.id }, :title => _("{{model}} filtered by {{filtered_by}}", :model => model_to_relate.model_name.human.pluralize, :filtered_by => @item.to_label)}
    #{add_new}
    </h2>
        HTML

        ##
        # It's a has_many relationship, so items that are already assigned to another
        # entry are assigned to that entry.
        #
        items_to_relate = model_to_relate.all(:conditions => ["#{foreign_key} is ?", nil])
        if condition && !items_to_relate.empty?
          html << <<-HTML
    #{form_tag :action => 'relate', :id => @item.id}
    #{hidden_field :related, :model, :value => model_to_relate}
    <p>#{select :related, :id, items_to_relate.collect { |f| [f.to_label, f.id] }.sort_by { |e| e.first } } &nbsp; #{submit_tag _("Add"), :class => 'button'}</p>
    </form>
          HTML
        end

        conditions = if model_to_relate.typus_options_for(:only_user_items) && @current_user.is_not_root?
                      { Typus.user_fk => @current_user }
                    end

        options = { :order => model_to_relate.typus_order_by, :conditions => conditions }
        items_count = @resource.find(params[:id]).send(field).count(:conditions => conditions)
        items_per_page = model_to_relate.typus_options_for(:per_page).to_i

        @pager = ::Paginator.new(items_count, items_per_page) do |offset, per_page|
          options.merge!({:limit => per_page, :offset => offset})
          items = @resource.find(params[:id]).send(field).all(options)
        end

        @items = @pager.page(params[:page])

        unless @items.empty?
          options = { :back_to => "#{@back_to}##{field}", :resource => @resource.to_resource, :resource_id => @item.id }
          html << build_list(model_to_relate, 
                             model_to_relate.typus_fields_for(:relationship), 
                             @items, 
                             model_to_relate_as_resource, 
                             options, 
                             association)
          html << pagination(:anchor => model_to_relate.to_resource) unless pagination.nil?
        else
          message = _("There are no {{records}}.", 
                      :records => model_to_relate.model_name.human.pluralize.downcase)
          html << <<-HTML
    <div id="flash" class="notice"><p>#{message}</p></div>
          HTML
        end
        html << <<-HTML
  </div>
        HTML
      end
    end

    # OPTIMIZE: Move html code to partial.
    def typus_form_has_and_belongs_to_many(field)
      returning(String.new) do |html|

        model_to_relate = @resource.reflect_on_association(field.to_sym).class_name.constantize
        model_to_relate_as_resource = model_to_relate.to_resource

        reflection = @resource.reflect_on_association(field.to_sym)
        association = reflection.macro

        condition = if @resource.typus_user_id? && @current_user.is_not_root?
                      @item.owned_by?(@current_user)
                    else
                      true
                    end

        if condition && @current_user.can?('create', model_to_relate)
          add_new = <<-HTML
    <small>#{link_to _("Add new"), :controller => field, :action => 'new', :back_to => @back_to, :resource => @resource.to_resource, :resource_id => @item.id}</small>
          HTML
        end

        html << <<-HTML
  <a name="#{field}"></a>
  <div class="box_relationships" id="#{model_to_relate_as_resource}">
    <h2>
    #{link_to model_to_relate.model_name.human.pluralize, :controller => "admin/#{model_to_relate_as_resource}"}
    #{add_new}
    </h2>
        HTML

        if model_to_relate.count < 500

          items_to_relate = (model_to_relate.all - @item.send(field))

          if condition && !items_to_relate.empty?
            html << <<-HTML
      #{form_tag :action => 'relate', :id => @item.id}
      #{hidden_field :related, :model, :value => model_to_relate}
      <p>#{select :related, :id, items_to_relate.collect { |f| [f.to_label, f.id] }.sort_by { |e| e.first } } &nbsp; #{submit_tag _("Add"), :class => 'button'}</p>
      </form>
            HTML
          end

        end

        conditions = if model_to_relate.typus_options_for(:only_user_items) && @current_user.is_not_root?
                      { Typus.user_fk => @current_user }
                    end

        options = { :order => model_to_relate.typus_order_by, :conditions => conditions }
        items_count = @resource.find(params[:id]).send(field).count(:conditions => conditions)
        items_per_page = model_to_relate.typus_options_for(:per_page).to_i

        @pager = ::Paginator.new(items_count, items_per_page) do |offset, per_page|
          options.merge!({:limit => per_page, :offset => offset})
          items = @resource.find(params[:id]).send(field).all(options)
        end

        @items = @pager.page(params[:page])

        unless @items.empty?
          html << build_list(model_to_relate, 
                             model_to_relate.typus_fields_for(:relationship), 
                             @items, 
                             model_to_relate_as_resource, 
                             {}, 
                             association)
          html << pagination(:anchor => model_to_relate.to_resource) unless pagination.nil?
        else
          message = _("There are no {{records}}.", 
                      :records => model_to_relate.model_name.human.pluralize.downcase)
          html << <<-HTML
    <div id="flash" class="notice"><p>#{message}</p></div>
          HTML
        end
        html << <<-HTML
  </div>
        HTML
      end
    end

    # OPTIMIZE: Move html code to partial.
    def typus_form_has_one(field)
      returning(String.new) do |html|

        model_to_relate = @resource.reflect_on_association(field.to_sym).class_name.constantize
        model_to_relate_as_resource = model_to_relate.to_resource

        reflection = @resource.reflect_on_association(field.to_sym)
        association = reflection.macro

        html << <<-HTML
  <a name="#{field}"></a>
  <div class="box_relationships">
    <h2>
    #{link_to model_to_relate.model_name.human, :controller => "admin/#{model_to_relate_as_resource}"}
    </h2>
        HTML
        items = Array.new
        items << @resource.find(params[:id]).send(field) unless @resource.find(params[:id]).send(field).nil?
        unless items.empty?
          options = { :back_to => @back_to, :resource => @resource.to_resource, :resource_id => @item.id }
          html << build_list(model_to_relate, 
                             model_to_relate.typus_fields_for(:relationship), 
                             items, 
                             model_to_relate_as_resource, 
                             options, 
                             association)
        else
          message = _("There is no {{records}}.", 
                      :records => model_to_relate.model_name.human.downcase)
          html << <<-HTML
    <div id="flash" class="notice"><p>#{message}</p></div>
          HTML
        end
        html << <<-HTML
  </div>
        HTML
      end
    end

    # OPTIMIZE: Remove returning(String.new) and return directly the html.
    def typus_belongs_to_field(attribute, options)

      form = options[:form]

      ##
      # We only can pass parameters to 'new' and 'edit', so this hack makes
      # the work to replace the current action.
      #
      params[:action] = (params[:action] == 'create') ? 'new' : params[:action]

      back_to = url_for(:controller => params[:controller], :action => params[:action], :id => params[:id])

      related = @resource.reflect_on_association(attribute.to_sym).class_name.constantize
      related_fk = @resource.reflect_on_association(attribute.to_sym).primary_key_name

      confirm = [ _("Are you sure you want to leave this page?"),
                  _("If you have made any changes to the fields without clicking the Save/Update entry button, your changes will be lost."), 
                  _("Click OK to continue, or click Cancel to stay on this page.") ]

      returning(String.new) do |html|

        message = link_to _("Add"), { :controller => "admin/#{related.to_resource}", 
                                      :action => 'new', 
                                      :back_to => back_to, 
                                      :selected => related_fk }, 
                                      :confirm => confirm.join("\n\n") if @current_user.can?('create', related)

        if related.respond_to?(:roots)
          html << typus_tree_field(related_fk, :items => related.roots, 
                                               :attribute_virtual => related_fk, 
                                               :form => form)
        else
          values = related.all(:order => related.typus_order_by).collect { |p| [p.to_label, p.id] }
          options = { :include_blank => true }
          html_options = { :disabled => attribute_disabled?(attribute) }
          label_text = @resource.human_attribute_name(attribute)
          html << <<-HTML
  <li>
    #{form.label related_fk, raw("#{label_text} <small>#{message}</small>")}
    #{form.select related_fk, values, options, html_options }
  </li>
          HTML
        end

      end

    end

  end

end
