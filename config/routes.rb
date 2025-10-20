Rails.application.routes.draw do
  devise_for :usuarios
  root "filmes#index"

  resources :filmes do
    resources :comentarios, only: [ :create, :destroy ]

    collection do
      post :importar
    end
  end

  resources :importacao_filmes, only: [ :index, :show ]
end