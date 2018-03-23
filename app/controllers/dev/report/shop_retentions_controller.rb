class Dev::Report::ShopRetentionsController < Dev::Report::BaseController
  include ActionSearchable
  include ActionExportable

  def index
    @report_shop_retentions = ReportShopRetention.all
    @report_shop_retentions = sort_records(relation: @report_shop_retentions, default_order: {report_date: :desc})

    preload_export(service: 'Dev::ShopRetention', action: 'report', relation: @report_shop_retentions)

    @report_shop_retentions = filter_by_pagination(relation: @report_shop_retentions)
  end
end