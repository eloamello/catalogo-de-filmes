require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :usuarios
  root "filmes#index"

  resources :filmes do
    resources :comentarios, only: [ :create, :destroy ]

    collection do
      post :importar
      post :buscar_por_ia
    end
  end

  resources :importacao_filmes, only: [ :index, :create ]

  resources :categorias, only: [ :index, :new, :create ]

  authenticate :usuario, lambda { |u| u.administrador? } do
    mount Sidekiq::Web => "/sidekiq"
  end
end