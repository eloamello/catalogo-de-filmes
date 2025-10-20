class ImportacaoFilme < ApplicationRecord
  enum :status, { em_andamento: 1, concluido: 2, erro: 3 }, default: :em_andamento
  has_one_attached :arquivo
  belongs_to :usuario
end
