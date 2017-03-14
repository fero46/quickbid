# coding: utf-8
require 'test_helper'

class AuctionDecoratorTest < ActiveSupport::TestCase
  def setup
    @auction = Auction.new.extend AuctionDecorator
  end

  # test "the truth" do
  #   assert true
  # end
end
