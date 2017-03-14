class AddIndeces < ActiveRecord::Migration
  def up
    add_index :orders, :correct
  end

  def down
  end
end
