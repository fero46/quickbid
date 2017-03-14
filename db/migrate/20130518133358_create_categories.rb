class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :image
      t.integer :category_id
      t.integer :order_value
      t.boolean :is_leaf
    end
    add_index :categories, :category_id
    add_index :categories, :order_value
  end
end
