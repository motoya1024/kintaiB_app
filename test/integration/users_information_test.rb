require 'test_helper'

class UsersInformationTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "unsuccessful edit information" do
    log_in_as(@user)
    get information_user_path(@user)
    assert_template 'users/information'
    patch informationupdate_user_path(@user), params: { user: { basic_time:  "",
                                              specifed_time: "" } }
    assert_template 'users/information'
    assert_select "div.alert", "下記の2つのエラーがあります。"
  end 
  
  test "successful edit information" do
    log_in_as(@user)
    get information_user_path(@user)
    assert_template 'users/information'
    basic_time =  "2000-01-01 12:45"
    specifed_time = "2000-01-01 14:45"
    patch informationupdate_user_path(@user), params: { user: { basic_time:  basic_time,
                                              specifed_time: specifed_time } }
    assert_not flash.empty?
    assert_template 'users/information'
    @user.reload
    assert_equal basic_time,  @user.basic_time.strftime('%Y-%m-%d %H:%M')
    assert_equal specifed_time, @user.specifed_time.strftime('%Y-%m-%d %H:%M')
  end 

  
end
