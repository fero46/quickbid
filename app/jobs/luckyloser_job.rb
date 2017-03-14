class LuckyloserJob
  include Sidekiq::Worker

  def perform
    calculate
  end

  def calculate(startDate = Time.now.beginning_of_week.to_date)
    luckyloser = Luckyloser.find_or_create_by_startday(startDate)
    dayli_payments = DayliPayment.where('created_at >= ?', startDate.to_datetime).where('created_at < ?',startDate.to_datetime + 7.days)
    list = {}
    for dayli_payment in dayli_payments
      user_id = dayli_payment.user_id
      list[user_id]=0.0 if list[user_id].blank?  
      list[user_id] = list[user_id] + dayli_payment.value
    end
    list = list.sort_by {|_key, value| value}.reverse
    counter = 0
    array = []
    list.each do |item|
      break if counter >= 10 
      array[counter] = item
      counter= counter + 1
    end  
    luckyloser.ranking = array
    luckyloser.save
  end

end