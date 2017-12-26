require 'test_helper'

class Dev::Report::ShopControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dev_report_shop_index_url
    assert_response :success
  end

end
