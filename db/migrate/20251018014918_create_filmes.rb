class CreateFilmes < ActiveRecord::Migration[8.0]
  def change
    create_table :filmes do |t|
      t.string :titulo
      t.text :sinopse
      t.integer :ano
      t.integer :duracao
      t.string :diretor

      t.timestamps
    end
  end
end
