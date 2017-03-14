class CreateOrderVariations < ActiveRecord::Migration
  def change
    create_table :order_variations do |t|
      t.integer :order_id
      t.string :group_name
      t.string :value

      t.timestamps
    end

    add_index :order_variations, :order_id
  end
end
