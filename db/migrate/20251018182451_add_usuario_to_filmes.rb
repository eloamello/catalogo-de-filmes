class AddUsuarioToFilmes < ActiveRecord::Migration[8.0]
  def change
    add_reference :filmes, :usuario, null: false, foreign_key: true
  end
end
