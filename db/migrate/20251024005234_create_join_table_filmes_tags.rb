class CreateJoinTableFilmesTags < ActiveRecord::Migration[8.0]
  def change
    create_join_table :filmes, :tags do |t|
      t.index [:filme_id, :tag_id]
      t.index [:tag_id, :filme_id]
    end
  end
end
