require 'clockwork'
include Clockwork
require File.expand_path('../config/boot', __FILE__)
require File.expand_path('../config/environment', __FILE__)

every(1.hour, 'auction.state.check') { Delayed::Job.enqueue(AuctionsJob.new) }
# every(1.minute, 'auction.winner.check') { Delayed::Job.enqueue(WinnersJob.new) }
every(1.hour, 'luckyloser.check'){ Delayed::Job.enqueue(LuckyloserJob.new) }
every(1.day, 'auto.auction', :at => '00:30') { Delayed::Job.enqueue(AutoAuctionJob.new) }

