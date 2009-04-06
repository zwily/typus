class << ActionController::Routing::Routes;self;end.class_eval do
  define_method :clear!, lambda {}
end

ActionController::Routing::Routes.draw do |map|

  path_prefix = Typus::Configuration.options[:path_prefix]

  map.with_options :controller => 'typus', :path_prefix => path_prefix do |i|
    i.admin_quick_edit 'quick_edit', :action => 'quick_edit'
    i.admin_dashboard '', :action => 'dashboard'
    i.admin_sign_in 'sign_in', :action => 'sign_in'
    i.admin_sign_out 'sign_out', :action => 'sign_out'
    i.admin_sign_up 'sign_up', :action => 'sign_up'
    i.admin_recover_password 'recover_password', :action => 'recover_password'
    i.admin_reset_password 'reset_password', :action => 'reset_password'
    i.admin_set_locale 'set_locale', :action => 'set_locale'
  end

  map.namespace :admin do |admin|

    Typus.resources.each do |resource|
      admin.connect "#{resource.underscore}/:action", :controller => resource.underscore, :path_prefix => path_prefix
    end

    Typus.models.each do |m|
      admin.with_options(:path_prefix => path_prefix, :controller  => m.tableize) do |opt|

        # Index action with format to be able to export items in CSV & XML.
        opt.connect m.tableize, :action => 'index', :conditions => { :method => :get }
        opt.connect "#{m.tableize}.:format", :action => 'index', :conditions => { :method => :get }

        opt.connect m.tableize, :action => 'create', :conditions => { :method => :post }

        opt.connect "#{m.tableize}/:id/edit", :action => 'edit', :conditions => { :method => :get }
        opt.connect "#{m.tableize}/:id", :action => 'update', :conditions => { :method => :put }
        opt.connect "#{m.tableize}/:id", :action => 'destroy', :conditions => { :method => :delete }

        # More actions.
        opt.connect "#{m.tableize}/:action"
        opt.connect "#{m.tableize}/:id/:action"

      end
    end

  end

end