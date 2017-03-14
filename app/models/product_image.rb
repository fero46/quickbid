class ProductImage < ActiveRecord::Base
  belongs_to :product
  attr_accessible :product_id, :image, :image_cache
  validates :image, :presence => true
  mount_uploader :image, ProductImageUploader

end
