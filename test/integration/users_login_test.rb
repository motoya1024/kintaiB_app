require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
    
  def setup
    @user = users(:michael)
    
    @other_user = users(:archer)
  end
  
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
   test "admin login with valid information" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?                                       
    assert_redirected_to timecard_path @user
    follow_redirect!
    assert_template 'timecards/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", information_user_path(@user)
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", edit_user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", users_path,      count: 0
    assert_select "a[href=?]", information_user_path(@user),      count: 0
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", edit_user_path(@user), count: 0
  end
  
  test "user login with valid information" do
    get login_path
    post login_path, params: { session: { email:    @other_user.email,
                                          password: 'password' } }
    assert is_logged_in?                                       
    assert_redirected_to timecard_path @other_user
    follow_redirect!
    assert_template 'timecards/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", users_path, count:0
    assert_select "a[href=?]", information_user_path(@other_user),count:0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", edit_user_path(@other_user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", edit_user_path(@user), count: 0
  end
  
end
