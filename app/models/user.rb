class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  validates :username, :presence => true, :uniqueness => {
    :case_sensitive => false
  }

  devise :database_authenticatable, :async, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  validates_acceptance_of :terms, :acceptance => true, :on => :create, :if => :has_to_accept

  has_many :bid_histories
  has_many :orders
  has_many :payments
  has_many :dayli_payments

  before_create :random_code
  before_save :init_data
  after_create :check_invitation_reference


  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :inviter_reference, :terms, :skip_terms, :free_bids, :refered_from
  
  def self.USER; "USER"; end
  def self.ADMIN; "ADMIN"; end
  def self.AGENT; "AGENT"; end
  

  def has_to_accept
    skip_terms.blank?
  end

  def skip_terms=value
    @skip_terms=value
  end

  def skip_terms
    @skip_terms
  end

  def inviter
    User.where(invite_code: self[:inviter_reference]).first
  end

  def check_invitation_reference
    self[:invite_code_checked] = self[:inviter_reference].blank?
    # See String#encode
    encoding_options = {
      :invalid           => :replace,  # Replace invalid byte sequences
      :undef             => :replace,  # Replace anything not defined in ASCII
      :replace           => '',        # Use a blank for those replacements
      :universal_newline => true       # Always break lines with \n
    }
    self[:username] = self[:username].encode(Encoding.find('ASCII'), encoding_options) if self[:username].present?
    save
  end

  def update_invite_counter
    User.transaction do 
      increment!(:invite_counter)
      reload
      num = 0
      num = 10 if invite_counter == 5
      num = 15 if invite_counter == 20
      num = 20 if invite_counter == 50
      num = 50 if invite_counter == 100
      num = 80 if invite_counter == 200
      if num > 0
        self.free_bids = self.free_bids + num
        save!
      end
    end
  end

  def perecents_of_invitation
   ((invite_counter * 100).to_f / 200).to_f
  end


  def bid_count
    self.free_bids + self.paid_bids
  end


  def self.next_bot auction_id
    bot = User.where(:bot => true).where(:last_auction => auction_id).first 
    bot = User.where(:bot => true).order(:bid_counter).first unless bot
    return bot
  end

  def self.next_first_bid_bot auction_id
    bot = User.where(:bot => true).where(:last_first_auto_bid => auction_id).first 
    bot = User.where(:bot => true).order(:last_first_autobid_counter).first unless bot
    return bot
  end

  def self.next_second_bid_bot auction_id, first_id
    bot = User.where(:bot => true).where(:last_second_auto_bid => auction_id).where('id NOT IN (?)', first_id).first 
    bot = User.where(:bot => true).where('id NOT IN (?)', first_id).order(:last_second_autobid_counter).first unless bot
    return bot
  end

  def username=username
    if username.blank?
      self[:username]=""
    else
      self[:username]=username.downcase
    end
  end

  def is_admin?
    self.role == User.ADMIN
  end

  def is_agent?
    self.role == User.AGENT
  end

  def is_bot?
    self.bot
  end


  def can_bid?
    bid_count > 0 || is_bot?
  end

  def has_free_bids?
    self.free_bids > 0
  end

  private

  def random_code
    invite_code = ''
    accounting_code = ''
    begin
      invite_code = String.random_alphanumeric()
    end while User.where(invite_code: invite_code).present?
    begin
      accounting_code = String.random_alphanumeric()
    end while User.where(accounting_code: accounting_code).present?
    self.invite_code=invite_code
    self.accounting_code=accounting_code
    self.free_bids = 35 
  end

  def init_data
    self.last_present_day ||= Date.today if new_record?
  end


end
