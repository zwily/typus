class << ActionController::Routing::Routes;self;end.class_eval do
  define_method :clear!, lambda {}
end

ActionController::Routing::Routes.draw do |map|

  map.with_options :controller => 'typus', :path_prefix => Typus::Configuration.options[:prefix] do |i|
    i.admin_quick_edit 'quick_edit', :action => 'quick_edit'
    i.admin_dashboard '', :action => 'dashboard'
    i.admin_overview 'overview', :action => 'overview'
    i.admin_login 'login', :action => 'login'
    i.admin_logout 'logout', :action => 'logout'
    i.admin_setup 'setup', :action => 'setup'
    i.admin_recover_password 'recover_password', :action => 'recover_password'
    i.admin_reset_password 'reset_password', :action => 'reset_password'
  end

  map.namespace :admin do |admin|
    Typus.models.each do |m|
      collection = {}
      m.typus_actions_for(:index).each { |a| collection[a] = :any }
      member = { :position => :any, :toggle => :any, :relate => :any, :unrelate => :any }
      m.typus_actions_for(:edit).each { |a| member[a] = :any }
      admin.resources m.tableize, :collection => collection, :member => member, :path_prefix => Typus::Configuration.options[:prefix]
    end
  end

end