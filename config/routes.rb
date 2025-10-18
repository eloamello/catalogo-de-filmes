Rails.application.routes.draw do
  devise_for :usuarios
  root "filmes#index"
  resources :comentarios
  resources :filmes
end