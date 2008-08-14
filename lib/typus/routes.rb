class << ActionController::Routing::Routes;self;end.class_eval do
  define_method :clear!, lambda {}
end

ActionController::Routing::Routes.draw do |map|

  map.with_options :controller => 'typus' do |i|
    i.typus_dashboard "admin", :action => 'dashboard'
    i.typus_login "admin/login", :action => 'login'
    i.typus_logout "admin/logout", :action => 'logout'
    i.typus_email_password "admin/email_password", :action => 'email_password'
  end

=begin

  map.with_options :controller => 'admin' do |i|
    i.connect "admin/:model/:action", :requirements => { :action => /index|new|create/ }
    i.connect "admin/:model/:id/:action", :requirements => { :action => /show|edit|update|destroy|position|toggle|relate|unrelate/, :id => /\d+/ }
  end

=end

  Typus.models.map { |m| m.tableize }.each do |model|
    map.connect "admin/#{model}/:action", :controller => "admin/#{model}"
    map.connect "admin/#{model}/:id/:action", :controller => "admin/#{model}"
  end

  map.namespace :admin do |admin|

    Typus.models.each do |m|
      admin.resources m.tableize, :member => { :position => :get, 
                                               :toggle => :get, 
                                               :relate => :get, 
                                               :unrelate => :get }
    end

  end

end