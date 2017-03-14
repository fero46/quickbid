class Luckyloser < ActiveRecord::Base 
  attr_accessible :ranking, :startday
  serialize :ranking
end
