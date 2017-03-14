class WelcomeController < ApplicationController
  def index
    @auctions = Auction.newest
    @hot_auctions = Auction.hot_auctions
    @show_image = true
  end
end
