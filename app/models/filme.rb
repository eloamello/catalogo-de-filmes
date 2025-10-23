class Filme < ApplicationRecord
  has_one_attached :poster
  has_and_belongs_to_many :categorias
  has_many :tags, dependent: :destroy
  has_many :comentarios, -> { order(created_at: :desc) }, dependent: :destroy
  belongs_to :usuario

  accepts_nested_attributes_for :tags, allow_destroy: true

  validates :titulo, :sinopse, :duracao, :diretor, presence: true
  validates :ano, presence: true, numericality: {
    only_integer: true,
    greater_than: 1878,
    less_than_or_equal_to: Date.current.year
  }

  scope :por_categorias, ->(categoria_ids) {
    return all if categoria_ids.blank?
    joins(:categorias).where(categorias: { id: categoria_ids }).distinct
  }
  def self.ransackable_associations(auth_object = nil)
    [ "categorias" ]
  end
  def self.ransackable_attributes(auth_object = nil)
    [ "ano", "diretor", "titulo" ]
  end
end
