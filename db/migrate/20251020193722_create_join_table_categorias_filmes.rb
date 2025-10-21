class CreateJoinTableCategoriasFilmes < ActiveRecord::Migration[8.0]
  def change
    create_join_table :categorias, :filmes do |t|
      t.index [:categoria_id, :filme_id]
      t.index [:filme_id, :categoria_id]
    end
  end
end
