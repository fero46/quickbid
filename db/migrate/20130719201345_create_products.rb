class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :brand
      t.string :short_description
      t.text :description
      t.decimal :price,  :precision => 10, :scale => 2
      t.string :remote_id
      t.string :online_shop
      t.string :shop_url
      t.timestamps
    end
    add_index :products, :remote_id
    add_index :products, [:remote_id, :online_shop], :uniqure => true
  end
end
