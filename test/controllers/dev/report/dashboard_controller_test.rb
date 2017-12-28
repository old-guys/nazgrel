require 'test_helper'

class Dev::Report::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dev_report_dashboard_index_url
    assert_response :success
  end

end
