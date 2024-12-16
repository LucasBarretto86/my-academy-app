Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  defaults format: :json do
    post "/sign-up", to: "registrations#create", as: :sign_up
    post "/sign-in", to: "session#create", as: :sign_in
    delete "/sign-out", to: "session#destroy", as: :sign_out

    namespace :api do
      namespace :v1 do
        resources :users, only: [:show, :update, :destroy]

        resources :courses, only: [:index, :show, :create, :update, :destroy] do
          scope module: :courses do
            resources :lessons, only: [:index, :show, :create, :update, :destroy]

            collection do
              resource :search, only: [:show], as: :course_search
            end
          end
        end
      end
    end
  end
end
