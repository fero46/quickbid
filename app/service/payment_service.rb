class PaymentService

  PAYPAL_CERT_PEM = File.read("#{Rails.root}/certs/#{Settings.paypal.paypal_cert}")
  APP_CERT_PEM = File.read("#{Rails.root}/certs/#{Settings.paypal.certs_name_pem}")
  APP_KEY_PEM = File.read("#{Rails.root}/certs/#{Settings.paypal.certs_name_key}")

  def payment_configuration_auction auction
    {
      invoice_number: auction.accounting_code,
      amount: auction.total.to_f,
      name: auction.product.short_description + " "+auction.product.brand,
      number: auction.product.short_description + " "+ auction.product.brand
    }
  end

  def create_payment_for_bids bids, user
    {
      invoice_number: user.accounting_code,
      amount: bids[:amount],
      name: bids[:name],
      number: bids[:name]
    }
  end

 
  def paypal_url(options, return_url, notify_url)
    invoiceID =Payment.count + 1 + rand(1...10000)
    values = {
      :business => Settings.paypal.mail,
      :cmd => '_cart',
      :upload => 1,
      :return => return_url,
      :invoice => "#{options[:invoice_number]}_#{invoiceID}",
      :notify_url => notify_url,
      :currency_code => "EUR",
      :cert_id => Settings.paypal.cert_id
    }
    values.merge!({
        "amount_1" => options[:amount],
        "item_name_1" => options[:name],
        "item_number_1" => options[:number],
        "quantity_1" => 1
    })
    query = {:cmd => "_s-xclick", :encrypted => encrypt_for_paypal(values)}
    Settings.paypal.url + query.to_query
  end
    
  def encrypt_for_paypal(values)
      signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(APP_CERT_PEM),        
                                    OpenSSL::PKey::RSA.new(APP_KEY_PEM, ''), 
                                    values.map { |k, v| "#{k}=#{v}" }.join("\n"), 
                                    [], 
                                    OpenSSL::PKCS7::BINARY)
      OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(PAYPAL_CERT_PEM)], 
                              signed.to_der, 
                              OpenSSL::Cipher::Cipher::new("DES3"),
                              OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")
  end

end