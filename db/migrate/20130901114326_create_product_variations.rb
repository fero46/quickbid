class CreateProductVariations < ActiveRecord::Migration
  def change
    create_table :product_variations do |t|
      t.integer :product_id
      t.integer :variation_group_id
      t.string :value
      t.timestamps
    end
    add_index :product_variations, :product_id
    add_index :product_variations, :variation_group_id
  end
end
