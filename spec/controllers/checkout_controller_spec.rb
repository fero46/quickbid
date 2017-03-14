require 'spec_helper'

describe CheckoutController do

  describe "GET 'create'" do
    it "returns http success" do
      get 'create'
      response.should be_success
    end
  end

  describe "GET 'paypal'" do
    it "returns http success" do
      get 'paypal'
      response.should be_success
    end
  end

end
