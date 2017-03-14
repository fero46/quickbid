class Category < ActiveRecord::Base
  
  belongs_to :category
  has_many :categories
  has_many :auctions
  has_many :products  
  scope :toplevel, where(:category_id => nil)


  attr_accessible :name, :order_value, :category_id, :is_leaf, :image
  mount_uploader :image, ConfigImageUploader

  def category_name
    I18n.t "category.#{self.name}"
  end

  def subcategories
    self.categories.order("order_value")
  end


  def find_ordered_products
    category_ids  = []
    category_ids << self.id 
    subcategories.each { |c| category_ids << c.id}

    return Product.where(:category_id => category_ids)
  end

  def find_ordered_auctions
    category_ids  = []
    category_ids << self.id 
    subcategories.each { |c| category_ids << c.id}

    return Auction.running_auctions.where(:category_id => category_ids)

  end

  def firstlevel?
    self.category_id == nil
  end

  def self.child_nodes
    Category.where(:is_leaf => true).collect {|p| [ p.node_name_with_parent , p.id ] }
  end

  def node_name_with_parent
    name = "#{self.category_name}"
    if category_id != nil
      name = "#{category.category_name} - #{name}"
    end
    name
  end

  def same_category mycat
    self.name.eql? mycat.name
  end


end
