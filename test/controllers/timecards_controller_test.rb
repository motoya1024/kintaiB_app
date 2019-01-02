require 'test_helper'

class TimecardsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
  
  test "should redirect show when not logged in" do
    get timecard_path(@user)
    assert_redirected_to login_url
  end
  
  test "should redirect edit when not logged in" do
    get edit_timecard_path(@user)
    assert_redirected_to login_url
  end
  
  test "should redirect edit when not admin logged in as wrong user" do
    log_in_as(@other_user)
    get edit_timecard_path(@user)
    assert_redirected_to login_url
  end
  
  test "should redirect show when not admin logged in as wrong user" do
    log_in_as(@other_user)
    get timecard_path(@user)
    assert_redirected_to login_url
  end

  
end
