ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper
  # Add more helper methods to be used by all tests here...
  
  # テストユーザーがログイン中の場合にtrueを返す
  def is_logged_in?
    !session[:user_id].nil?
  end
  
  # テストユーザーとしてログインする
  def log_in_as(user)
    session[:user_id] = user.id
  end

end

class ActionDispatch::IntegrationTest

  # テストユーザーとしてログインする
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
  
  def monthly_time_cards(user, year, month)
        number_of_days_in_month = Date.new(year, month, 1).next_month.prev_day.day    #指定年月末を取得
        results = Array.new(number_of_days_in_month) # 月の日数分nilで埋めた配列を用意
        time_cards = Timecard.monthly(user,year,month)   #ユーザーごとの指定年月のtimecard履歴を取得
           #ユーザーごとの指定年月のtimecard履歴をループしてインデックスを付与する
         time_cards.each do |card|
             results[card.day - 1] = card
         end
        results
  end 
  
  
  
  
end
