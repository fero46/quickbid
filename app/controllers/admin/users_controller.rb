class Admin::UsersController < Admin::AdminController

  before_filter :only_admins

  def index
    symbol = :index
    @users = User.where(bot: false).where(:role => User.USER).order(:email).page(params[:page]).per(8)
    current_navigation[symbol]='active'
    @total_count = User.where(bot:false).where(:role => User.USER).count
  end

  def show
    current_navigation[:show]='active'
    @user = User.find(params[:id])
  end

  def edit
    current_navigation[:edit]='active'
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    current_navigation[:edit]='active'
    if @user.update_attributes(params[:user])
      redirect_to admin_user_path(@user)
    else
      render 'edit'
    end
  end

end