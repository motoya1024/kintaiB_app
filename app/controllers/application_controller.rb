class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  def hello
    render html: "hello, world!"
  end
  
  private
   # ログイン済みユーザーかどうか確認
    def logged_in
      unless logged_in?
        store_location
        flash[:danger] = "ログインして下さい。"
        redirect_to login_url
      end
    end
    
     # ログイン済みユーザーかどうか確認
    def logged_in_admin
      unless admin_logged_in?
        store_location
        flash[:danger] = "ログインして下さい。"
        redirect_to login_url
      end
    end
  
    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless user_logged_in?
        store_location
        flash[:danger] = "ログインして下さい。"
        redirect_to login_url
      end
    end
  
  
  
  
end
