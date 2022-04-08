Rails.application.routes.draw do

	devise_for :users
  resources :users
  
	root to: "application#index"

  get 'new_title_or_apocryphon', to: 'apocrypha#form_container'

  resources :person_references
  resources :modern_source_references
  resources :source_urls
  resources :modern_sources do
    collection do
      post :create_from_booklist
      post :create_from_text
      post :create_from_manuscript
    end
  end
  resources :sections
  resources :booklist_references
  resources :booklists
  resources :text_urls
  resources :texts
  resources :contents do
    collection do
      put :sort
      post :move_to_booklet
    end
  end
  resources :titles do
    collection do
      post :create_from_content
    end
  end
  resources :apocrypha do
    collection do
      post :create_from_booklist
    end
  end
  resources :ownerships do
    collection do
      put :sort
    end
  end
  resources :people
  resources :booklets do
    collection do
      put :sort
      post :create_from_booklist
    end
    resources :contents do
      resources :texts
    end
  end
  resources :manuscripts do
    post :revert_known_composition
    collection do
      post :create_from_booklist
    end
    resources :booklets do
      collection do
        post :create_from_booklist
      end
      resources :contents do
        collection do
          post :create_from_booklist
        end
        resources :texts
      end
    end
    resources :contents do
      resources :texts
    end
  end
  resources :language_references
  resources :institutional_affiliations
  resources :religious_orders
  resources :institutions
  resources :languages
  resources :locations
  resources :writing_systems
  resources :change_logs
  resources :booklist_sections

end
