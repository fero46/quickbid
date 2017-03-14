class AuctionsJob

    include Sidekiq::Worker
    def perform
      @auctions = Auction.past_auctions.where(state: Auction.STARTET)
      for auction in @auctions
        user = auction.try(:lastbidder).try(:user)
        state = Auction.BOT
        if user.present?
          state = Auction.USER unless user.is_bot?
        end
        auction.state = state
        if auction.category.blank?
          category = Category.order("RAND()").first
          auction.category_id = category.id 
        end
        auction.save
      end
    end

end

