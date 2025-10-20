class Usuario < ApplicationRecord
  has_many :filmes, dependent: :nullify
  has_many :comentarios, dependent: :destroy
  has_many :importacao_filmes, dependent: :nullify

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
