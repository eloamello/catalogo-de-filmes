Rails.application.routes.draw do
  devise_for :usuarios
  root "filmes#index"

  resources :filmes do
    resources :comentarios, only: [ :create, :destroy ]

    collection do
      post :importar
    end
  end

  authenticate :usuario, lambda { |u| u.administrador? } do
    mount Sidekiq::Web => "/sidekiq"
  end
end