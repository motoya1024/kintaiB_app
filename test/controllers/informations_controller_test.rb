require 'test_helper'

class InformationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get informations_new_url
    assert_response :success
  end

end
