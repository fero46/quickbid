class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :auction_id
      t.integer :user_id
      t.string :name
      t.string :lastname
      t.string :street
      t.string :streetnumber
      t.string :zipcode
      t.string :city
      t.text :note
      t.boolean :correct
      t.timestamps
    end

    add_index :orders, :auction_id, :unique => true
    add_index :orders, :user_id
  end
end
