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
    def self.draw(map)

      map.with_options :controller => 'admin/account' do |i|
        # i.admin_quick_edit 'quick_edit', :action => 'quick_edit'
        i.admin_sign_in 'admin/sign_in', :action => 'sign_in'
        i.admin_sign_out 'admin/sign_out', :action => 'sign_out'
        i.admin_sign_up 'admin/sign_up', :action => 'sign_up'
        i.admin_recover_password 'admin/recover_password', :action => 'recover_password'
        i.admin_reset_password 'admin/reset_password', :action => 'reset_password'
      end

      map.with_options :controller => 'admin/dashboard' do |i|
        i.connect 'admin', :action => 'index'
        i.admin_dashboard 'admin/dashboard', :action => 'index'
      end

      map.connect ':controller/:action/:id', :controller => /admin\/\w+/
      map.connect ':controller/:action/:id.:format', :controller => /admin\/\w+/

    end

  end

end
