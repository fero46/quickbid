class CreateAuctionConfigurations < ActiveRecord::Migration
  def change
    create_table :auction_configurations do |t|
      t.string :name
      t.string :day_in_week
      t.string :day_part
      t.timestamps
    end
    add_index :auction_configurations, :name
    add_index :auction_configurations, :day_in_week
  end
end
