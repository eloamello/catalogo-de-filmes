class Filme < ApplicationRecord
  has_one_attached :poster
  has_and_belongs_to_many :categorias
  has_and_belongs_to_many :tags
  has_many :comentarios, -> { order(created_at: :desc) }, dependent: :destroy
  belongs_to :usuario

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

  def tags_texto
    tags.pluck(:nome).join(" ")
  end

  def tags_texto=(valor)
    return if valor.blank?
    nomes_tags = valor.split(/\s+/).map(&:strip).reject(&:blank?).uniq
    self.tags = nomes_tags.map do |nome|
      Tag.find_or_create_by(nome: nome.downcase)
    end
  end

  def self.ransackable_scopes(auth_object = nil)
    %i[por_categorias]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[categorias]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[ano diretor titulo]
  end
end
