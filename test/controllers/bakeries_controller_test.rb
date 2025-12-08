require "test_helper"

class BakeriesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get bakeries_new_url
    assert_response :success
  end

  test "should get create" do
    get bakeries_create_url
    assert_response :success
  end
end
