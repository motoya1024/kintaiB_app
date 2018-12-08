class UsersController < ApplicationController
  
  before_action :logged_in, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_admin, only: [:index, :information, :informationupdate]
  before_action :correct_user,   only: [:show, :edit, :update]
  before_action :admin_user,     only: :destroy
  
  def new
    @user = User.new
  end
  
  def index
    #@users = User.where(activated: true).paginate(page: params[:page])
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
   # redirect_to root_url and return unless @user.activated?
  end
  
  def information
    @user = User.find(current_user.id)
  
  end
  
  def informationupdate
    
    @user = User.find(current_user.id)
    if @user.update_attributes(information_params)
      flash[:success] = "基本情報を更新しました。"
      render 'information'
    else
      render 'information'
    end
  
  end
  
  def create
    @user = User.new(user_params)    # 実装は終わっていないことに注意!
    if @user.save
       #@user.send_activation_email
       #flash[:info] = "Please check your email to activate your account."
       flash[:success] = "プロフィールを更新しました。"
       redirect_to root_url
      
       #log_in @user
       #flash[:success] = "Welcome to the Sample App!"
       #redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def destroy
    log_out
    redirect_to root_url
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールを更新しました。"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザー情報を消去しました。"
    redirect_to users_url
  end

  private
    def user_params
        params.require(:user).permit(:name, :email, :password, :department,
                                     :password_confirmation)
    end
    
    def information_params
        params.require(:user).permit(:specifed_time, :basic_time)
    end

    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
end
