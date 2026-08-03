Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    resources :users, only: [ :create ]
    resources :sessions, only: [ :new, :create ]
    resources :tasks, only: [ :index, :create ], param: :task_id do
      member do
        put :complete
        put :incomplete
      end
    end
    post "tasks/:task_id/favorite", to: "favorite_tasks#create"
    delete "tasks/:task_id/favorite", to: "favorite_tasks#destroy"
    put "users/follow/:target_user_id", to: "follows#create"
    delete "users/follow/:target_user_id", to: "follows#destroy"
  end
end
