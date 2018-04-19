class Dev::Report::CumulativeProductSalesActivitiesController < Dev::Report::BaseController
  include ActionSearchable
  include ActionExportable

  def index
    @report_cumulative_product_sales_activities = ReportCumulativeProductSalesActivity.
      preload(product: {
        category: :parent,
        product_brand_supplier: [:brand, :supplier]
      })

    if params[:released_at].present?
      _dates = range_within_datetime(str: params[:released_at])

      @report_cumulative_product_sales_activities = @report_cumulative_product_sales_activities.joins(:product).where(products: {released_at: _dates})
    end

    preload_export(service: 'Dev::CumulativeProductSalesActivity', action: 'report', relation: @report_cumulative_product_sales_activities)

    @report_cumulative_product_sales_activities = filter_by_pagination(relation: @report_cumulative_product_sales_activities)
  end
end