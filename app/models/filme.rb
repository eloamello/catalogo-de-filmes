class Filme < ApplicationRecord
  has_many :comentarios, dependent: :destroy
  belongs_to :usuario

  validates :titulo, :sinopse, :ano, :duracao, :diretor, presence: true
end