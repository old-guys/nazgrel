class Api::ZmallMobile::ShopsController < Api::ZmallMobile::BaseController
  include ActionSearchable
  include ActionUtilable

  before_action :set_shop

  def summary
  end

  def stat
    @report_shop_activities = 0.upto(11).map{|i|
      date = i.send(:month).ago.end_of_month

      ReportShopActivity.where(
        shop_id: @shop.id,
        report_date: date.all_month
      ).last
    }.compact
  end

  private
  def set_shop
    @shop = Shop.find(params[:id])
  end
end