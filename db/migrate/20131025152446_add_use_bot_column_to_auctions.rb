class AddUseBotColumnToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :deactivate_bots, :boolean, :default => false
  end
end
