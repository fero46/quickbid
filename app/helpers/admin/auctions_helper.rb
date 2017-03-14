module Admin::AuctionsHelper


  def winners_user_name auction
    user = auction.try(:lastbidder).try(:user)
    return "Kein Gewinner" if user.blank? || !auction.time_is_over?
    bot = user.is_bot? 
    (user.username + (bot ? " <BOT>" : "")).upcase
  end

  def order_path_if_exists auction
    " NO ORDER " if auction.order.blank?
  end

end