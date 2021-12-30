Rails.application.routes.draw do
  resources :apocrypha
  
  devise_for :users
  root to: "application#index"

  resources :booklets
  resources :manuscripts

end
