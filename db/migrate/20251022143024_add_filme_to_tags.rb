class AddFilmeToTags < ActiveRecord::Migration[8.0]
  def change
    add_reference :tags, :filme, null: false, foreign_key: true
  end
end
