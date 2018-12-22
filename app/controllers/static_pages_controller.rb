class StaticPagesController < ApplicationController
  def home
    if logged_in?
        @user = User.find(current_user.id)
    end
  end

end
