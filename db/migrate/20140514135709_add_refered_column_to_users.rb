class AddReferedColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :refered_from, :string, default: ""
    add_index :users, :refered_from
  end
end
