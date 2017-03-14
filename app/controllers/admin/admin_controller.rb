class Admin::AdminController < ApplicationController

  before_filter :check_authorization
  before_filter :current_navigation

  def only_admins
    redirect_to admin_root_path if is_agent?
    return
  end

private
  
  def check_authorization
    unless is_authorized?
      redirect_to root_path
    end
  end

  def is_authorized?
    current_user && (is_admin? || is_agent?)
  end

  def is_admin?
   current_user.is_admin?
  end

  def is_agent?
    current_user.is_agent?
  end

  def current_navigation
    @current_navigation = {}
  end

end