class CreateBidHistories < ActiveRecord::Migration
  def change
    create_table :bid_histories do |t|
      t.integer :auction_id
      t.integer :user_id
      t.timestamps
    end
    add_index :bid_histories, :auction_id
    add_index :bid_histories, :user_id
  end
end
