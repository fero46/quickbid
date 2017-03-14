class Product < ActiveRecord::Base
  has_many :auctions
  has_many :product_images
  has_many :product_variations
  has_many :auction_configuration_memberships, :class_name => "AuctionConfigurationMembership"
  has_many :auction_configurations, through: :auction_configuration_memberships
  belongs_to :category
  attr_accessible :remote_id, 
                  :brand, 
                  :short_description, 
                  :price, :description, 
                  :online_shop, 
                  :shop_url, 
                  :product_images_attributes, 
                  :shipment_price, 
                  :product_variations_attributes,
                  :category_id, 
                  :activated,
                  :auction_configuration_memberships_attributes

  accepts_nested_attributes_for :product_images, :reject_if => lambda { |a| a[:image].blank? },  :allow_destroy => true
  accepts_nested_attributes_for :product_variations, :reject_if => lambda { |a| a[:value].blank? },  :allow_destroy => true
  accepts_nested_attributes_for :auction_configuration_memberships, :reject_if => lambda { |a| a[:auction_configuration_id].blank? },  :allow_destroy => true


    validates :brand, :presence => true
    validates :short_description, :presence => true
    validates :description, :presence => true
    validates :price, :presence => true
    validates :shipment_price, :presence => true
    validates :online_shop, :presence => true
    validates :shop_url, :presence => true
    validates :category_id, :presence => true
    validates :description, :presence => true
    validates :product_images, :length => { :minimum => 1 , :message => " zu wenig. minimum 1 Bild"}
    


  def string_to_float(input)
     return nil if input.blank?
     string = "#{input}"
     string.gsub!(/[^\d.,]/,'')     
     if string =~ /^.*[\.,]\d{1}$/
       string = string + "0"
     end
     unless string =~ /^.*[\.,]\d{2}$/  
       string = string + "00"
     end
     string.gsub!(/[\.,]/,'')
     return (string.to_f / 100).to_s
  end

  def price=val
    self[:price]=string_to_float(val)
  end

  def shipment_price=val
    self[:shipment_price]=string_to_float(val)
  end

  def main_image
    product_images.first.image
  end

  def has_variations?
    product_variations.present? && product_variations.count > 0
  end

  def variation_groups
    return [] if self.product_variations.blank?
    self.product_variations.joins(:variation_group).group('variation_groups.name').select('variation_groups.name as name').map{|n| n.name }
  end

  def variation_values group_name
    return [] if product_variations.blank?
    vari_id = VariationGroup.where(name: group_name).try(:first).try(:id)
    return [] if vari_id.blank? || vari_id == 0
    product_variations.where(variation_group_id: vari_id)
  end

  def as_json(options={})
    super(:only => [:id, :price,:brand,:short_description],
        :include => {
          :product_images => {:only => [:image]},
        }
    )
  end

end