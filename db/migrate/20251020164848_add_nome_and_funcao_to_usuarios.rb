class AddNomeAndFuncaoToUsuarios < ActiveRecord::Migration[8.0]
  def change
    add_column :usuarios, :nome, :string
    add_column :usuarios, :funcao, :integer
  end
end
