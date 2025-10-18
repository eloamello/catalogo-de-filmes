class Filme < ApplicationRecord
  has_many :comentarios, dependent: :destroy

  validates :titulo, presence: true
  validates :sinopse, presence: true
  validates :ano, presence: true
  validates :duracao, presence: true
  validates :diretor, presence: true
end