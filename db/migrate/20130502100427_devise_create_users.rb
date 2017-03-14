class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :username
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""
      t.string :role, :null => false, :default => "USER"
      t.integer :credit, :null => false, :default => 0
      t.boolean :bot, :default => false
      t.integer :paid_bids, :default => 0
      t.integer :free_bids, :default => 3
      t.integer :bid_counter, :default => 0
      t.string :invite_code, :null => false
      t.string :inviter_reference, :default => nil
      t.string :invite_code_checked, :default => true
      t.integer :invite_counter, :default => 0, :null => false
      t.string :accounting_code, :null => false

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## Token authenticatable
      t.string :authentication_token
      t.integer :last_auction 

      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :confirmation_token,   :unique => true
    add_index :users, :invite_code,          :unique => true
    add_index :users, :accounting_code,      :unique => true

    # add_index :users, :unlock_token,         :unique => true
    add_index :users, :authentication_token, :unique => true
    add_index :users, :bot
    add_index :users, :last_auction, :default => 0
  end
end
