class Filme < ApplicationRecord
  has_one_attached :poster
  has_many :comentarios, -> { order(created_at: :desc) }, dependent: :destroy
  belongs_to :usuario

  validates :titulo, :sinopse, :ano, :duracao, :diretor, presence: true
end
