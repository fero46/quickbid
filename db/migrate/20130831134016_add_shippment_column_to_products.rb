class AddShippmentColumnToProducts < ActiveRecord::Migration
  def change
    add_column :products, :shipment_price, :decimal, :precision => 10, :scale => 2
  end
end
