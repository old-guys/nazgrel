require 'test_helper'

class Dev::Report::ReportShopActivityControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dev_report_report_shop_activity_index_url
    assert_response :success
  end

end
