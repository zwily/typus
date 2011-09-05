Rails.application.routes.draw do

  routes_block = lambda do

    dashboard = Typus.subdomain ? "/dashboard" : "/admin/dashboard"

    match "/" => redirect(dashboard)
    match "dashboard" => "dashboard#index", :as => "dashboard_index"
    match "dashboard/:application" => "dashboard#show", :as => "dashboard"

    if Typus.authentication == :session
      resource :session, :only => [:new, :create], :controller => :session do
        get :destroy, :as => "destroy"
      end

      resources :account, :only => [:new, :create, :show] do
        collection do
          get :forgot_password
          post :send_password
        end
      end
    end

    Typus.models.map { |i| i.to_resource }.each do |resource|
      match "#{resource}(/:action(/:id))(.:format)", :controller => resource
    end

    Typus.resources.map { |i| i.underscore }.each do |resource|
      match "#{resource}(/:action(/:id))(.:format)", :controller => resource
    end
  end

  if Typus.subdomain
    constraints :subdomain => Typus.subdomain do
      namespace :admin, :path => "", &routes_block
    end
  else
    scope "admin", {:module => :admin, :as => "admin"}, &routes_block
  end
end
