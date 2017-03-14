class AddFirstSaleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_sale, :boolean, default: true
  end
end
