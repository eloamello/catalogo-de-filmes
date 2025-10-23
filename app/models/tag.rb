class Tag < ApplicationRecord
  belongs_to :filme

  validates :nome, presence: true
end
