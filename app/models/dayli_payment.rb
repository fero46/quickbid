class DayliPayment < ActiveRecord::Base
  belongs_to :user
  attr_accessible :value, :user_id
end
