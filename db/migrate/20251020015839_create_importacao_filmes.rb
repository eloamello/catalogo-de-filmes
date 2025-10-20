class CreateImportacaoFilmes < ActiveRecord::Migration[8.0]
  def change
    create_table :importacao_filmes do |t|
      t.integer :status
      t.references :usuario, null: false, foreign_key: true

      t.timestamps
    end
  end
end
