class Partner < ActiveRecord::Base
  attr_accessible :adresse, :bank, :bic, :email, :firma, :fullname, 
                  :iban, :kontoinhaber, :notiz, :refcode, :telefon, :partner_code

  before_create :generate_refcode


  validates :fullname, :presence => true
  validates :email, :presence => true
  validates :adresse, :presence => true
  validates :bank, :presence => true
  validates :kontoinhaber, :presence => true
  validates :telefon, :presence => true
  validates :bic, :presence => true
  validates :iban, :presence => true


  def generate_refcode
    code = ""
    begin
      code = Partner.create_refcode
      user = Partner.where(refcode: code).first
    end while not user.blank?
    self.refcode = code
  end

  def String.random_alphanumeric(size=16)
      alphanumerics = [('0'..'9'),('A'..'Z'),('a'..'z')].map {|range| range.to_a}.flatten
      (0...size).map { alphanumerics[Kernel.rand(alphanumerics.size)] }.join
  end
      
  def self.create_refcode
    "#{String.random_alphanumeric(10).downcase}"
  end  

end
