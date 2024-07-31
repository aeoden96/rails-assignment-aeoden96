Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    resources :users, except: [:new, :edit]
    resources :companies, except: [:new, :edit]
    resources :flights, except: [:new, :edit]
    resources :bookings, except: [:new, :edit]
  end

end
