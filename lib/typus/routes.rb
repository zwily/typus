class << ActionController::Routing::Routes;self;end.class_eval do
  define_method :clear!, lambda {}
end

ActionController::Routing::Routes.draw do |map|

  map.with_options :path_prefix => Typus::Configuration.options[:path_prefix] do |typus|

    typus.with_options :controller => 'typus' do |i|
      i.admin_quick_edit 'quick_edit', :action => 'quick_edit'
      i.admin_dashboard '', :action => 'dashboard'
      i.admin_sign_in 'sign_in', :action => 'sign_in'
      i.admin_sign_out 'sign_out', :action => 'sign_out'
      i.admin_sign_up 'sign_up', :action => 'sign_up'
      i.admin_recover_password 'recover_password', :action => 'recover_password'
      i.admin_reset_password 'reset_password', :action => 'reset_password'
      i.admin_set_locale 'set_locale', :action => 'set_locale'
    end

    typus.namespace :admin do |i|

      Typus.resources.each do |resource|
        i.connect "#{resource.underscore}/:action", :controller => resource.underscore
      end

      Typus.models.each do |model|
        # i.connect "#{model.tableize}/:action", :controller => model.tableize
        # i.connect "#{model.tableize}/:id/:action", :controller => model.tableize
        i.connect "#{model.tableize}/:action/:id", :controller => model.tableize
        i.connect "#{model.tableize}/:action/:id.:format", :controller => model.tableize
      end

    end

  end

end