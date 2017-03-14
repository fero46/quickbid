class AuctionConfiguration < ActiveRecord::Base
  has_many :auction_configuration_memberships
  has_many :products, through: :auction_configuration_memberships
  
  attr_accessible :day_in_week, :day_part, :name

  validates :day_in_week, :presence => true
  validates :day_part, :presence => true
  validates :name, :presence => true

  DAY_IN_WEEK  = %w{monday tuesday wednesday thursday friday saturday sunday}
  DAY_PART  = %w{morning noon afternoon evening night}

  def self.day_in_weeks
    self.prepare_selection(DAY_IN_WEEK)
  end

  def self.day_parts
  	self.prepare_selection(DAY_PART)
  end

  def day_in_week_human
     I18n.t("auction_configuration.#{day_in_week}")
  end

  def day_part_human
     I18n.t("auction_configuration.#{day_part}")
  end

private
	
  def self.prepare_selection array
    array.collect {|p| [ I18n.t("auction_configuration.#{p}"), p] }
  end

end
