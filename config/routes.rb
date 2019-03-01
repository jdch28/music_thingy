Rails.application.routes.draw do
  resources :songs do
    member do
      get 'generate'
      get 'download'
    end
  end
end
