class Filme < ApplicationRecord
  has_many :comentarios, -> { order(created_at: :desc) }, dependent: :destroy
  belongs_to :usuario

  validates :titulo, :sinopse, :ano, :duracao, :diretor, presence: true
end