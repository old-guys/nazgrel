class DailyOperationalShopGradeSummary::UpdateReport
  class << self
    def update_report(report_date: Date.today, force_update: false, interval_time: 30.minutes)
      _record = ReportDailyOperationalShopGradeSummary.where(
        report_date: report_date
      ).first_or_initialize

      _time = Time.now

      return if !force_update and _record.persisted? and (_record.updated_at + interval_time) >= _time
      logger.info "update daily_operational report for: #{report_date}"

      _report = DailyOperationalShopGradeSummary::UpdateReport.new(
        record: _record,
        date: report_date
      )

      _report.perform
    end
  end
  include ReportUpdateable
  include ReportLoggerable

  include DailyOperationalShopGradeSummary::Calculations
  include ReportCalculationable

  attr_accessor :record, :date, :result

  def initialize(record: , date: )
    self.record = record
    self.date = date
  end

  private
  def process
    @result = calculate(date: date)

    record.assign_attributes(
      @result
    )
  end
end