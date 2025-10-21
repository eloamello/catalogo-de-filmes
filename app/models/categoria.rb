class Categoria < ApplicationRecord
  has_and_belongs_to_many :filmes
  validates :nome, presence: true, uniqueness: true

  def self.ransackable_associations(auth_object = nil)
    ["filmes"]
  end
  def self.ransackable_attributes(auth_object = nil)
    %w["id", "nome"]
  end
end
