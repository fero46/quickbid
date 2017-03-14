class NoticeController < ApplicationController
  def registration
    @user = User.where(invite_code: params[:token]).first
  end
end
