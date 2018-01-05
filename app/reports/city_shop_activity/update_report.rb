class CityShopActivity::UpdateReport
  class << self
    def update_report(city: , report_date: Date.today, force_update: false, interval_time: 30.minutes)
      report_shop_activities = ReportShopActivity.joins(:shopkeeper).where(
        shopkeepers: {city: city}
      )
      _record = ReportCityShopActivity.where(
        city: city,
        report_date: report_date
      ).first_or_create
      _time = Time.now

      return if not force_update and _record.persisted? and (_record.updated_at + interval_time) >= _time

      _report = CityShopActivity::UpdateReport.new(
        report_date: report_date,
        record: _record,
        city: city,
        report_shop_activities: report_shop_activities
      )

      _report.perform
    end

    def insert_to_partial_city(city: )
      _key = CITY_CACHE_KEY
      $redis.SADD(_key, city)
    end
  end
  include CityShopActivity::Calculations
  include ReportLoggerable

  CITY_CACHE_KEY = "city_shop_activity_report_cities"

  attr_accessor :date, :city, :record, :result, :report_shop_activities

  def initialize(report_date: ,record: ,city: ,report_shop_activities: )
    self.record = record
    self.city = city
    self.report_shop_activities = report_shop_activities

    self.date = record.report_date
  end

  def perform
    begin
      process

      write
    rescue => e
      logger.warn "update report failure #{e}, record: #{record.try(:attributes)}"
    end
  end

  private
  def process
    @result = calculate(report_shop_activities: report_shop_activities)

    record.assign_attributes(
      @result
    )
  end
  def write
    record.changed? && record.save
  end

  private
end