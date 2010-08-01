Rails.application.routes.draw do

  resource :admin, :only => [:show], :controller => :admin

  namespace :admin do

    resource :dashboard, :only => [:show], :controller => :dashboard
    resource :session, :only => [:new, :create, :destroy], :controller => :session
    resources :account, :only => [:new, :create, :show] do
      collection { get :forgot_password }
    end

    # We should find a way to include "the dynamic routing."
    # match ':controller(/:action(/:id(.:format)))'
    # map.connect ":controller/:action/:id", :controller => /admin\/\w+/
    # map.connect ":controller/:action/:id.:format", :controller => /admin\/\w+/
    Typus.models.map { |m| m.tableize }.each do |typus_resource|
      resources typus_resource do

        ##
        # FIXME: Remove hardcoded routes.
        ##

        member do
          get :toggle
          post :relate
          get :unrelate
          get :position
        end

        collection do
          get :sort
        end

      end
    end

  end

end
