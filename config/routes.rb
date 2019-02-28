Rails.application.routes.draw do
  resources :songs do
    member do
      get 'generate'
    end
  end
end
