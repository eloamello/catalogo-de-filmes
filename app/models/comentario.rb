class Comentario < ApplicationRecord
  belongs_to :filme
  belongs_to :usuario, optional: true

  validates :conteudo, presence: true
  validates :nome_visitante, presence: true, unless: :usuario?

  private
  def usuario?
    usuario.present?
  end
end
