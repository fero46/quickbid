class AddBotColumnToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :bot_bidder_1, :integer, :default => 0
    add_column :auctions, :bot_bidder_2, :integer, :default => 0
    add_column :auctions, :last_bidder_bot, :integer, :default => 0
  end
end
