class ThanksController < ApplicationController
  before_filter :authenticate_user!

  def index
     redirect_to root_path unless session[:payment_startet]
     first_sale = current_user.first_sale ? 1 : 0
     @options = "price=#{session[:payment_amount]}&newcust=#{first_sale}"
     if current_user.first_sale
        current_user.first_sale=false
        current_user.save
     end
     session[:payment_startet] = false
  end
end