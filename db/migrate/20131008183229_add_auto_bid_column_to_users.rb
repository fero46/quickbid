class AddAutoBidColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_second_autobid_counter, :integer, :default => 0
    add_column :users, :last_first_autobid_counter, :integer, :default => 0
    add_column :users, :last_first_auto_bid, :integer, :default => 0
    add_column :users, :last_second_auto_bid, :integer, :default => 0
  end
end
