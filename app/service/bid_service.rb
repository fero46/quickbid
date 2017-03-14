#encoding: UTF-8
class BidService
  def self.convert_to_bid_amounts options
    case options.to_i
        when 1
          {
            amount: 5.00,
            name: "10 GEBOTE - 5 EUR"   
          }
        when 2
          {
            amount: 10.00,
            name: "20 GEBOTE - 10,00 EUR"   
          }
        when 3
          {
            amount: 15.00,
            name: "30 GEBOTE - 15,00 EUR"   
          }
        when 4
          {
            amount: 25.00,
            name: "50 GEBOTE - 25 EUR"   
          }
        when 5 
          {
            amount: 50.00,
            name: "100 GEBOTE - 50 EUR" 
          }
        else
          nil
    end
  end
end