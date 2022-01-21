Rails.application.routes.draw do
  
	devise_for :users
	root to: "application#index"

  resources :person_references
  resources :modern_source_references
  resources :source_urls
  resources :modern_sources
  resources :sections
  resources :booklist_references
  resources :booklists
  resources :text_urls
  resources :texts
  resources :contents do
    collection do
      put :sort
    end
  end
  resources :titles
  resources :apocrypha
  resources :ownerships
  resources :people
  resources :booklets do
    collection do
        put :sort
      end
  end
  resources :manuscripts do
      resources :booklets do
        resources :contents
      end
      resources :contents
  end
  resources :language_references
  resources :institutional_affiliations
  resources :religious_orders
  resources :institutions
  resources :languages
  resources :locations

end
