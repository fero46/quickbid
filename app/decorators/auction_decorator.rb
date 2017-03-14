# coding: utf-8
module AuctionDecorator

  def is_active?
    self.end >= DateTime.now && self.start <= DateTime.now
  end

  def revenue
    (bids ? bids : 0) * 0.50 + (bids ? bids.to_f / 100 : 0)
  end


  def winner? user
    return false if lastbidder.blank?
    lastbidder.user.id == user.id
  end

end
