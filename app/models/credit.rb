class Credit
  def self.VALUE_FOR_CREDIT_IN_CENT; 10; end;
  
  def self.calculate_required_credit regular_price
    price_in_cents = regular_price * 100
    price_in_cents = price_in_cents.to_i
    p price_in_cents
    actual_credit = 0
    iteration = 0
    while (actual_credit - 1) * Credit.VALUE_FOR_CREDIT_IN_CENT < price_in_cents
      actual_credit = actual_credit + iteration
      iteration += 1
    end
    iteration
  end
end