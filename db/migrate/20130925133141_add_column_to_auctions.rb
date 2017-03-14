class AddColumnToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :checked, :boolean, :default => false
    add_column :auctions, :winner, :integer, :default => nil
    add_index :auctions, :checked
    add_index :auctions, :winner
  end
end
