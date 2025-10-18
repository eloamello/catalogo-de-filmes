Rails.application.routes.draw do
  root "filmes#index"
  resources :comentarios
  resources :filmes
end
