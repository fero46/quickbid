class VariationGroup < ActiveRecord::Base
  has_many :product_variations
  attr_accessible :name


  def translated_name
    I18n.t ("variation_group.#{self.name}")
  end
end
