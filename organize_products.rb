require './config/boot'
require './config/environment'

require 'find'

require 'fileutils'

auction_configurations = AuctionConfiguration.all
i=0
for auction_configuration in auction_configurations
  products = Product.all
  for product in products
    isblank = AuctionConfigurationMembership.
            where(auction_configuration_id: auction_configuration.id).
            where(product_id: product.id).blank?
    if isblank
      i=i+1;
      AuctionConfigurationMembership.create!(auction_configuration_id: auction_configuration.id,
                                            product_id: product.id)
    end
  end
end

puts "#{i} Auktionkonfiguration zu Produkt hinzugefügt."