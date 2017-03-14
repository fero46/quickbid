class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.text :params
      t.integer :user_id
      t.string :status
      t.string :transaction_id
      t.string :action
      t.timestamps
    end
    add_index :payments, :user_id
    add_index :payments, :transaction_id
  end
end
