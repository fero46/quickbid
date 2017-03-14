class AutoAuctionJob

  DAY_IN_WEEK  = %w{sunday monday tuesday wednesday thursday friday saturday}


  def perform
    auto_auction
  end

  def auto_auction date=DateTime.tomorrow
    wday = DAY_IN_WEEK[date.wday]
    auction_configurations = AuctionConfiguration.where(day_in_week: wday)
    for auction_configuration in auction_configurations
      day_part = auction_configuration.day_part
      p day_part
      basetime = 0
      case day_part
      when "morning"
        basetime = 9
      when "noon" 
        basetime = 12
      when "afternoon" 
        basetime = 15
      when "evening" 
        basetime = 18
      when "night"
        basetime = 21
      else
        basetime = 6
      end
      products = auction_configuration.products
      for product in products
        variation = Random.rand(120)
        starttime = basetime.hours + variation.minutes
        endingtime = starttime + 10.minutes
        starttime_date = date + starttime
        endingtime_date = date + endingtime
        Auction.create!(:product_id => product.id, :end => endingtime_date, :start => starttime_date, category_id: product.category_id)
      end
    end
  end
end