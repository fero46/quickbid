class BidHistory < ActiveRecord::Base
  belongs_to :auction
  belongs_to :user
  attr_accessible :auction_id, :user_id

  def as_json(options={})
    {
      'time' => I18n.l(created_at, format: :short),
      'user' => user.blank? ? "" : user.username
    }
  end

end
