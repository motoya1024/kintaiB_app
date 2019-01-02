require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @base_title = "勤怠システム"
  end
  
  test "should get home" do
    get root_url
    assert_response :success
    assert_select "title", "勤怠システム"
  end


end
