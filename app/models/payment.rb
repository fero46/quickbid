class Payment < ActiveRecord::Base
  

  attr_accessible :params, :status, :transaction_id, :user_id, :action

  belongs_to :user
  serialize :params
  after_create :mark_payment_as_purchased


  def self.BUY_BIDS; "BUY_BIDS"; end
  def self.PAY_AUCTION; "PAY_AUCTION"; end
  
private
  def mark_payment_as_purchased
    if status == "Completed" && params[:secret] == Settings.payment.secret
      if self.action == Payment.BUY_BIDS
        values_to_choos_from = {1 => 10, 2 => 20, 3 => 30, 4 => 50, 5 => 100}
        if params[:selected_bid].present? && is_num?(params[:selected_bid])
          bids = values_to_choos_from[params[:selected_bid].to_i]
          if bids.present?
            self.user.paid_bids = self.user.paid_bids + bids
            self.user.save
          end
        end
      elsif self.action == Payment.PAY_AUCTION
        auction = Auction.where(:accounting_code => params[:auction]).first
        if auction.present?
          auction.state = Auction.READY_TO_SHIP
          auction.save
        end
      end
     else

    end
  end


  def is_num?(str)
    begin
      !!Integer(str)
    rescue ArgumentError, TypeError
      false
    end
  end

end
