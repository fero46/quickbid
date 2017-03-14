class Order < ActiveRecord::Base

  belongs_to :auction
  belongs_to :user
  has_many :order_variations

  attr_accessible :auction_id, :city, :correct, :lastname, :name, :note, :street, :streetnumber, :user_id, :zipcode, :order_variations_attributes
  
  accepts_nested_attributes_for :order_variations


  validates :name, :presence => true
  validates :lastname, :presence => true
  validates :street, :presence => true
  validates :streetnumber, :presence => true
  validates :city, :presence => true
  validates :zipcode, :presence => true

  after_save :set_order_status

  def set_order_status
    if auction.present? && correct
      auction.state = Auction.UNPAYED
      auction.save
    end
  end

end
