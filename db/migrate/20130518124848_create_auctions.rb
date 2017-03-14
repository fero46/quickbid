class CreateAuctions < ActiveRecord::Migration
  def change
    create_table :auctions do |t|
      t.datetime :start, :null => false
      t.datetime :end, :null => false
      t.string  :state, :null => false
      t.integer :product_id, :null => false
      t.integer :required_bids, :null => false, :default => 0
      t.integer :bids, :null => false, :default => 0
      t.integer :intern_bids, :null => false, :default => 0
      t.integer :timer
      t.integer :category_id
      t.integer :visits, :null => false, :default => 0
      t.string :accounting_code, null: false

      t.timestamps
    end

    add_index :auctions, :start
    add_index :auctions, :end
    add_index :auctions, :product_id
    add_index :auctions, :category_id
    add_index :auctions, :state
    add_index :auctions, :accounting_code, unique: true

  end
end
