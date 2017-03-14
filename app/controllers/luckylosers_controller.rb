class LuckylosersController < ApplicationController

  def show
    startDate = Time.now.beginning_of_week.to_date
    @luckloser = Luckyloser.where(startday: startDate).first
    @ranking = @luckloser.blank? ? [] : (@luckloser.ranking.blank? ? [] : @luckloser.ranking)
    @ranking = make_ranking @ranking
  end
  

  private 

  def make_ranking ranking
    size = ranking.size
    loopsize = 10 - size
    loopsize.times do |counter|
      ranking[size + counter] = []
    end
    ranking
  end

end
