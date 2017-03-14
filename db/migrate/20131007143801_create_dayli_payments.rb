class CreateDayliPayments < ActiveRecord::Migration
  def change
    create_table :dayli_payments do |t|
      t.integer :user_id
      t.decimal :value,  :precision => 10, :scale => 2
      t.timestamps
    end
    add_index :dayli_payments, :user_id
    add_index :dayli_payments, :created_at
  end
end
