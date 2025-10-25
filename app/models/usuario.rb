class Usuario < ApplicationRecord
  enum :funcao, { usuario: 0, administrador: 1 }, default: :usuario

  has_many :filmes, dependent: :nullify
  has_many :comentarios, dependent: :destroy
  has_many :importacao_filmes, dependent: :nullify

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :nome, presence: true
end
