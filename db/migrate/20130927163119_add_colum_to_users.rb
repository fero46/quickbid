class AddColumToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_present_day, :date
  end
end
