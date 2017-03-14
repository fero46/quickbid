class AuctionConfigurationMembership < ActiveRecord::Base
  
  attr_accessible :auction_configuration_id, :product_id
  
  belongs_to :auction_configuration
  belongs_to :product
  
  validates :auction_configuration_id, :presence => true
  validates :product_id, :presence => true
  validates :product_id, :uniqueness => {:scope => :auction_configuration_id}

end
