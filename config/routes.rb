Rails.application.routes.draw do
  
  root to: 'fridges#index'

  resources :fridges do
  	member do
  	  post 'add_ingredient', to: 'fridges#add_ingredient'
      delete 'remove_ingredient', to: 'fridges#remove_ingredient'
      get 'recipes', to: 'fridges#recipes'
    end
  end

  resources :ingredients
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
