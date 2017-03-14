class AddColumToProducts < ActiveRecord::Migration
  def change
    add_column :products, :category_id, :integer
    add_column :products, :activated, :boolean, default: false
    add_index :products, :category_id
    add_index :products, :activated
  end
end
