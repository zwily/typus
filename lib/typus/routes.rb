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

  map.namespace :admin do |admin|

    Typus.models.each do |m|
      admin.resources m.tableize, :collection => { :csv => :get }, 
                                  :member => { :position => :any, 
                                               :toggle => :any, 
                                               :relate => :any, 
                                               :unrelate => :any }
    end

  end

end