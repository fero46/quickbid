class OrderVariation < ActiveRecord::Base

  belongs_to :order

  attr_accessible :group_name, :order_id, :value

  validates :value, :presence => true
  validates :group_name, :presence => true

end
