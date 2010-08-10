Rails.application.routes.draw do

  resource :admin, :only => [:show], :controller => :admin

  namespace :admin do

    resource :dashboard, :only => [:show], :controller => :dashboard
    resource :session, :only => [:new, :create, :destroy], :controller => :session
    resources :account, :only => [:new, :create, :show, :forgot_password] do
      collection { get :forgot_password }
    end

  end

  match ':controller(/:action(/:id))', :controller => /admin\/[^\/]+/

end
