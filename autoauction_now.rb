require './config/boot'
require './config/environment'

require 'find'

require 'fileutils'

AutoAuctionJob.new.auto_auction Date.today