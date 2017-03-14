class ProductVariation < ActiveRecord::Base
  
  belongs_to :product
  belongs_to :variation_group

  attr_accessible :product_id, :value, :variation_group_id
end
