class Auction < ActiveRecord::Base

  belongs_to :category
  has_many :bid_histories
  belongs_to :product
  attr_accessible  :start, :end, :product_id, :state, :category_id, :deactivate_bots
  has_one :order

  attr_accessor :ignore_over_time, :detail

  before_create :calculate_min_required_bid
  before_create :set_state
  before_create :set_random_code
  after_create :set_accounting_code

  validates :category, :presence => true
  validates :category_id, :presence => true
  validates :product_id, :presence => true
  validates :start, :presence => true
  validates :end, :auction_time => true

  #constants
  
  def self.BOT; "BOT"; end
  def self.USER; "USER"; end
  def self.UNPAYED; "UNPAYED"; end
  def self.STARTET; "STARTET"; end
  def self.READY_TO_SHIP; "READY_TO_SHIP"; end
  def self.CLOSED; "CLOSED"; end

  def self.states
    [ Auction.BOT,
      Auction.USER,
      Auction.UNPAYED,
      Auction.STARTET,
      Auction.READY_TO_SHIP,
      Auction.CLOSED
    ]
  end


  def has_to_bid?
    self. intern_bids < (self.required_bids * 0.40).to_i
  end

  def lastbidder_is_bot?
    mylastbidder = lastbidder
    return false if mylastbidder.blank?
    user = mylastbidder.user
    return false if user.blank?
    return user.is_bot?
  end

  def self.hot_auctions
    Auction.where('end >= ?', DateTime.current).where('start <= ?', DateTime.current).order("end").where(deactivate_bots: true).limit(8)
  end

  def self.newest
    Auction.where('end >= ?', DateTime.current).where('start <= ?', DateTime.current).order("end").where(deactivate_bots: false).limit(8)
  end

  def self.running_auctions
    Auction.where('end >= ?', DateTime.current).where('start <= ?', DateTime.current).order("end").where(deactivate_bots: false)
  end

  def self.future_auctions
    where('start >= ?', DateTime.current).order('start DESC')
  end

  def self.next_auctions
    where('start >= ?', DateTime.current).order(:created_at).group(:product_id).limit(5)
  end

  def self.past_auctions
    where('end < ?', DateTime.current).order('start DESC')
  end

  def set_state
    self.state=Auction.STARTET
  end

  def set_random_code
    accounting_code = String.random_alphanumeric(2)
    date = Date.current
    day = fill_with_zero date.day
    month = fill_with_zero date.month
    year = date.year
    self.accounting_code="#{accounting_code}#{day}#{month}#{year}-"
  end

  def set_accounting_code
    self.accounting_code="#{self.accounting_code}#{self.id}"
    save
  end

  def fill_with_zero number
    if number.to_i < 10
      return "0#{number}"
    else
      return number
    end
  end

  def calculate_min_required_bid
    self.required_bids = ((self.product.price) / 0.50 + 1).round
  end

  def self.active_auctions
    where('end >= ?', DateTime.current).where('start <= ?', DateTime.current ).order(:end)
  end

  def self.active_auctions_last_endet_auctions
    where('end >= ?', DateTime.current - 30.seconds).where('start <= ?', DateTime.current ).order(:end)
  end

  def self.finished_but_unpayed
    where(:state => Auction.UNPAYED)
  end

  def self.finished_and_ready_to_ship
    where(:state => Auction.READY_TO_SHIP)
  end

  def lastbidder
    BidHistory.where(:auction_id => self.id).order('created_at DESC').first
  end

  def ignore_over_time(value)
    @ignore_over_time=value
  end

  def price_value
    actual_value
  end

  def actual_value
    0.01 * (bids ? bids : 0) 
  end

  def shipment
    return 0 if self.product.shipment_price.blank?
    self.product.shipment_price
  end

  def total
    shipment + actual_value
  end
  
  def lastbidder_user_name
    return lastbidder.user.username if lastbidder && lastbidder.user
    ""
  end

  def last_seconds?
    (self[:end] - 10.seconds) <= Time.current
  end

  def last_minute?
    (self[:end] - 1.minutes) <= Time.current
  end

  def add_ten_seconds
    self[:end] = Time.current() + 10.seconds
    save!
  end

  def ending_time 
    return "0:0:0" if time_is_over?
    difference= self.end.time - Time.current() - 2.hours
    ChronicDuration.output(difference, :format => :chrono).to_s.split('.')[0]
  end

  def time_is_over?
     self[:end] < (Time.current) - 2.seconds
  end

  def set_options
    @detail= true
  end
  
  def take_bid user, normal_bid=1
    Auction.transaction {
      return if lastbidder? user
      return unless user.can_bid?
      unless @ignore_over_time
        return if time_is_over?
      end
      increment!(:bids)
      if user.has_free_bids?
        user.decrement!(:free_bids)
      else
        user.decrement!(:paid_bids)
        increment!(:intern_bids)
      end
      add_ten_seconds if last_seconds?
      self.bid_histories.build(:user_id => user.id).save
      broadcast
    }
  end

  def lastbidder? user
    user != nil && self.lastbidder != nil && self.lastbidder.user != nil &&  self.lastbidder.user.id == user.id
  end

  def broadcast
#    client = Faye::Client.new('http://localhost:9292/faye')
#    client.publish("/auction/update#{self.id}", to_json)
  end

  def release_auction?
    self.intern_bids > self.required_bids
  end

  def latest_ten
    BidHistory.where(auction_id: self.id).order("created_at DESC").limit(10)
  end

  def to_json(options={})
    {
      'price' => price_value,
      'lastbidder' => lastbidder_user_name(),
      'finished' => self[:end],
      'last_seconds' => last_seconds?,
      'bid_history' => latest_ten.to_json,
      :ext => {:auth_token => FAYE_TOKEN}
    }
  end

  def url_safe url
    url.downcase.gsub(/[^a-zA-Z0-9]+/, '-').gsub(/-{2,}/, '-').gsub(/^-|-$/, '')
  end

  def to_param
    "#{id}-#{url_safe(I18n.l(self.start, format: :short).to_s)}-#{url_safe(self.product.short_description)}"
  end

  def has_variations?
    return false if product.blank?
    product.has_variations?
  end

  def variation_groups
    [] if product.blank?
    product.variation_groups
  end

  def variation_values variation_groups
    [] if product.blank?
    product.variation_values variation_groups
  end
  
  def is_endet?
    time_is_over?
  end

end
