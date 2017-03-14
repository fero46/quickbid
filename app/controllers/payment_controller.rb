class PaymentController < ApplicationController

  before_filter :authenticate_user!

  def buy
  end
  
end
