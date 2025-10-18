class Usuario < ApplicationRecord
  has_many :filmes, dependent: :destroy
  has_many :comentarios, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
