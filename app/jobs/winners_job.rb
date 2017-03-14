class WinnersJob
    include Sidekiq::Worker
    def perform
        time = DateTime.current - 10.minutes
        @auctions = Auction.where('end < ?', time).where(checked: false).order('start DESC')
        for auction in @auctions
          lastbidder = auction.lastbidder
          user =  lastbidder.blank? ? nil : lastbidder.user
          auction.winner = user.blank? ? nil : user.id 
          auction.checked = true
          auction.save 
        end
    end
end