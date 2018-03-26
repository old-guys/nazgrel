class ProductRepurchase::UpdateReport
  class << self
    def update_week_report(report_date: Date.today, force_update: false, interval_time: 30.minutes)
      report_date = report_date.beginning_of_week
      _end_at = (report_date - 1).to_time.end_of_week

      update_report(
        report_date: report_date,
        start_at: _end_at.beginning_of_week,
        end_at: _end_at,
        force_update: force_update, interval_time: interval_time
      )
    end

    def update_month_report(report_date: Date.today, force_update: false, interval_time: 30.minutes)
      report_date = report_date.beginning_of_month
      _end_at = (report_date - 1).to_time.end_of_month

      update_report(
        report_date: report_date,
        start_at: _end_at.beginning_of_month,
        end_at: _end_at,
        force_update: force_update, interval_time: interval_time
      )
    end

    private
    def update_report(report_date: , start_at: , end_at: , force_update: false, interval_time: 30.minutes)
      _categories = Category.level_1

      _records =  ReportProductRepurchase.where(
        start_at: start_at,
        end_at: end_at,
        category_id: _categories
      )
      _time = Time.now

      _categories.each {|category|
        _record = _records.find{|record|
          record.category_id == category.id
        } || ReportProductRepurchase.new(
          report_date: report_date,
          start_at: start_at,
          end_at: end_at,
          category: category
        )

        return if !force_update and _record.persisted? and (_record.updated_at + interval_time) >= _time
        logger.info "update product_repurchase report for: #{report_date} category: #{category}(#{category.id})"

        _report = ProductRepurchase::UpdateReport.new(
          record: _record,
          start_at: start_at,
          end_at: end_at,
          category: category
        )

        _report.perform
      }
    end
  end
  include ProductRepurchase::Calculations
  include ReportLoggerable
  include ReportCalculationable

  attr_accessor :record, :start_at, :end_at, :category

  def initialize(record: , start_at: , end_at: , category: )
    self.record = record
    self.start_at = start_at
    self.end_at = end_at
    self.category = category
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
    @result = calculate(start_at: start_at, end_at: end_at, category: category)

    record.assign_attributes(
      @result
    )
  end
  def write
    record.changed? ? record.save : record.touch
  end

  private
end