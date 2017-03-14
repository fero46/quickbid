module OrdersHelper

  def decode_order_status status
    return "Abgeschickt" if status == Auction.CLOSED
    return "In bearbeitung - Zahlung empfangen." if status == Auction.READY_TO_SHIP
    "Warte auf Zahlungseingang"
  end

end
