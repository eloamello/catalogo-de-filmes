class CreateComentarios < ActiveRecord::Migration[8.0]
  def change
    create_table :comentarios do |t|
      t.references :filme, null: false, foreign_key: true
      t.string :nome_visitante
      t.text :conteudo

      t.timestamps
    end
  end
end
