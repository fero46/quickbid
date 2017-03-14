class CreateAuctionConfigurationMemberships < ActiveRecord::Migration
  def change
    create_table :auction_configuration_memberships do |t|
      t.integer :product_id
      t.integer :auction_configuration_id
      t.timestamps
    end
    add_index :auction_configuration_memberships, :product_id, name: 'acm_pr'
    add_index :auction_configuration_memberships, :auction_configuration_id, name: 'acm_ac'
    add_index :auction_configuration_memberships, [:product_id, :auction_configuration_id], unique: true, name: 'acm_pr_ac'
  end
end
