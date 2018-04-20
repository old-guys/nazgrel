class CumulativeProductSalesActivity::UpdateReport
  class << self
    def update_report(report_date: Date.today, force_update: false, touch_report_date: true, interval_time: 30.minutes)
      _products = Product.online.where(
        "created_at <= ?", report_date.to_datetime.end_of_day
      )
      _records = ReportCumulativeProductSalesActivity.where(
        product_id: _products.map(&:id)
      )

      _time = Time.now
      _products.each {|product|
        _record = _records.find{|record|
          record.product_id == product.id
        } || ReportCumulativeProductSalesActivity.new(
          report_date: report_date,
          product: product
        )

        return if !force_update and _record.persisted? and (_record.updated_at + interval_time) >= _time
        logger.info "update cumulative_product_sales_activity report for: #{report_date} category: #{product}(#{product.id})"

        _record.report_date = Date.today if touch_report_date
        _report = CumulativeProductSalesActivity::UpdateReport.new(
          record: _record,
          date: report_date,
          product: product
        )

        _report.perform
      }
    end
  end
  include ReportUpdateable
  include ReportLoggerable

  include CumulativeProductSalesActivity::Calculations
  include ReportCalculationable

  attr_accessor :record, :date, :product, :result

  def initialize(record: , date: , product:)
    self.record = record
    self.date = date
    self.product = product
  end

  private
  def process
    @result = calculate(date: date, product: product, only_due_quarter: true)

    record.assign_attributes(
      @result
    )
  end
end