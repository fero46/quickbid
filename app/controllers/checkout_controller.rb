class CheckoutController < ApplicationController

  before_filter :authenticate_user!, :except => [:notify_buy_paypal, :notify_auctions_paypal]

  protect_from_forgery :except => [:notify_buy_paypal, :notify_auctions_paypal]


  def notify_buy_paypal
    # dirty hack
    params.each {|k,v| params[k]=v.force_encoding('iso-8859-1').encode('utf-8') if v.kind_of?(String)}
    payment = Payment.create!(:params => params, 
                    :user_id => params[:user], 
                    :status => params[:payment_status], 
                    :transaction_id => params[:txn_id],
                    :action => Payment.BUY_BIDS)
    DayliPayment.create!( :user_id => payment.user_id,
                          :value => payment.params['mc_gross'])
    render :nothing => true
  end

  def notify_auctions_paypal
    # dirty hack
    params.each {|k,v| params[k]=v.force_encoding('iso-8859-1').encode('utf-8') if v.kind_of?(String)}
    Payment.create!(:params => params, 
                    :user_id => params[:user], 
                    :status => params[:payment_status], 
                    :transaction_id => params[:txn_id],
                    :action => Payment.PAY_AUCTION)
    render :nothing => true
  end


  def buy_bids
    options = BidService.convert_to_bid_amounts params[:option]
    if options.blank?
      redirect_to buy_bid_path
    end
    payment_service = PaymentService.new
    payment_options = payment_service.create_payment_for_bids(options, current_user)
    payment_configuration payment_options
    redirect_to payment_service.paypal_url(payment_options, 
                                           thanks_url, 
                                           notify_buy_url(:secret => Settings.payment.secret, 
                                                          :user=>current_user.id,
                                                          :selected_bid => params[:option]))
  end

  def pay_auctions
    auction = Auction.where(:accounting_code => params[:code]).first
    if auction.blank? || !auction.lastbidder?(current_user)
      redirect_to root_path
      return
    end
    payment_service = PaymentService.new
    payment_options = payment_service.payment_configuration_auction(auction)
    payment_configuration payment_options
    redirect_to payment_service.paypal_url(payment_options, 
                                           thanks_url, 
                                           notify_buy_auctions_url(:secret => Settings.payment.secret, 
                                                          :user=>current_user.id,
                                                          :auction => auction.accounting_code))
  end


private 

  def payment_configuration options
    session[:payment_startet]  = true
    session[:payment_amount] = options[:amount]
  end

end
