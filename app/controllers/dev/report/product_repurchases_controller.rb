class Dev::Report::ProductRepurchasesController < Dev::Report::BaseController
  include ActionSearchable
  include ActionExportable

  def index
    params[:dismiss] ||= "week"

    @report_product_repurchases = ReportProductRepurchase.preload(:category).all
    @report_product_repurchases = @report_product_repurchases.where(
      start_at: params[:start_at], end_at: params[:end_at]
    )

    @report_product_repurchases = sort_records(relation: @report_product_repurchases, default_order: {report_date: :desc})

    preload_export(service: 'Dev::ProductRepurchase', action: 'report', relation: @report_product_repurchases)

    @report_product_repurchases = filter_by_pagination(relation: @report_product_repurchases)
  end
end