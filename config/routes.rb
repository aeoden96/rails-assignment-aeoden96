Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    resources :users, except: [:new, :edit]
    resources :companies, except: [:new, :edit]
    resources :flights, except: [:new, :edit]
    resources :bookings, except: [:new, :edit]
    resources :session do
      post :create, on: :collection
      delete :destroy, on: :collection
    end

    resources :statistics, only: [] do
      collection do
        get :flights, to: 'statistics#flights_index'
        get :companies, to: 'statistics#companies_index'
      end
    end
  end

end
