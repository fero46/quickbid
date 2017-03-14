class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_default_image
  before_filter :check_invite
  before_filter :check_default_auction
  before_filter :check_extra_credit
  before_filter :refcode



  def refcode
    if current_user.blank? && params[:refcode]
      cookies[:refcode] = params[:refcode]
      redirect_to root_path
    end
  end


  def check_extra_credit
    if current_user.present?
      last_present_day = current_user.last_present_day
      if last_present_day.blank? || (((Date.today) - last_present_day).to_i >0)
        current_user.last_present_day = Date.today
        current_user.free_bids = 0 if current_user.free_bids == nil
        current_user.free_bids = current_user.free_bids + 3
        current_user.save
        flash[:extra_bid] = true
      end
    end
  end


  def check_invite
    if current_user.present?
      cookies[:invite_from] = nil
      if current_user.invite_code_checked.to_i != 1
        inviter=current_user.inviter
        inviter.update_invite_counter if inviter.present?
        current_user.invite_code_checked=true
        current_user.save
      end
    else
      cookies[:invite_from] = params[:invite] if  params[:invite].present?
    end
  end

  def check_default_image
    @default_image = 'default.jpg' unless @default_image
    @default_title = 'FashionFly' unless @default_title
  end
  
  def after_sign_in_path_for(resource)
    return admin_root_path if resource.is_agent? || resource.is_admin?
    super
  end

  def check_default_auction
    @auction = @auctions.first if @auctions.present?
  end

end
