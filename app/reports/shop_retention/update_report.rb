class ShopRetention::UpdateReport
  class << self
    def update_report(report_date: Date.today.beginning_of_month, force_update: false, interval_time: 30.minutes)
      report_date = report_date.beginning_of_month

      _record = ReportShopRetention.where(
        report_date: report_date
      ).first_or_initialize

      _time = Time.now

      return if !force_update and _record.persisted? and (_record.updated_at + interval_time) >= _time
      logger.info "update shop_retention report for: #{report_date}"

      _report = ShopRetention::UpdateReport.new(
        record: _record,
        date: report_date
      )

      _report.perform
    end
  end
  include ShopRetention::Calculations
  include ReportLoggerable
  include ReportCalculationable

  attr_accessor :record, :date, :result

  def initialize(record: , date: )
    self.record = record
    self.date = date
  end

  def perform
    begin
      process

      write
    rescue => e
      logger.warn "update report failure #{e}, record: #{record.try(:attributes)}"
      log_error(e)
    end
  end

  private
  def process
    @result = calculate(date: date)

    record.assign_attributes(
      @result
    )
  end
  def write
    record.changed? ? record.save : record.touch
  end

  private
end