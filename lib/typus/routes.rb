module Typus

  class Routes

    # In your application's config/routes.rb, draw Typus's routes:
    #
    # @example
    #   map.resources :posts
    #   Typus::Routes.draw(map)
    #
    # If you need to override a Typus route, invoke your app route
    # earlier in the file so Rails' router short-circuits when it finds
    # your route:
    #
    # @example
    #   map.resources :users, :only => [:new, :create]
    #   Typus::Routes.draw(map)
    def self.draw(map, prefix = 'admin')

      map.with_options :controller => 'admin/account' do |i|
        # i.admin_quick_edit 'quick_edit', :action => 'quick_edit'
        i.admin_sign_in "#{prefix}/sign_in", :action => 'sign_in'
        i.admin_sign_out "#{prefix}/sign_out", :action => 'sign_out'
        i.admin_sign_up "#{prefix}/sign_up", :action => 'sign_up'
        i.admin_recover_password "#{prefix}/recover_password", :action => 'recover_password'
        i.admin_reset_password "#{prefix}/reset_password", :action => 'reset_password'
      end

      map.with_options :controller => 'admin/dashboard' do |i|
        i.connect "#{prefix}", :action => 'index'
        i.admin_dashboard "#{prefix}/dashboard", :action => 'index'
      end

      map.connect ':controller/:action/:id', :controller => /admin\/\w+/
      map.connect ':controller/:action/:id.:format', :controller => /admin\/\w+/

    end

  end

end
