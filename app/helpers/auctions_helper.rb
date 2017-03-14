module AuctionsHelper

  def create_auction_share_link auction
    if current_user
      auction_url(auction, invite: current_user.try(:invite_code))
    else
      auction_url(auction)
    end
  end

end
