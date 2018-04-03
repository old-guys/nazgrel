class CityShopActivity::UpdateReport
  class << self
    def update_report(city: , report_date: Date.today, force_update: false, interval_time: 30.minutes)
      _cities = Array.wrap(city)
      _exist_records = ReportCityShopActivity.where(
        city: _cities,
        report_date: report_date
      ).find_each.to_a
      _time = Time.now

      _records = _cities.map {|_city|
        _record = _exist_records.find{|record|
          record.city == _city
        } || ReportCityShopActivity.new(
          city: _city,
          report_date: report_date
        )
      }

      _records.each_slice(50).map {|records|
        _reports = records.map {|_record|
          report_shop_activities = ReportShopActivity.joins(:shopkeeper).where(
            shopkeepers: {city: _record.city},
            report_date: report_date
          )

          return if not force_update and _record.persisted? and (_record.updated_at + interval_time) >= _time

          _report = CityShopActivity::UpdateReport.new(
            report_date: report_date,
            record: _record,
            city: _record.city,
            report_shop_activities: report_shop_activities
          )

          _report.perform(skip_save: true)
          _report
        }.compact

        ReportCityShopActivity.transaction do
          _reports.compact.each(&:write)
        end
      }
    end

    def insert_to_partial_city(city: )
      _key = CITY_CACHE_KEY

      Array.wrap(city).uniq.each {|c|
        $redis.SADD(_key, c) if c.present?
      }
    end
  end
  include ReportUpdateable
  include ReportLoggerable

  include CityShopActivity::Calculations
  include ReportCalculationable

  CITY_CACHE_KEY = "city_shop_activity_report_cities"

  attr_accessor :date, :city, :record, :result, :report_shop_activities

  def initialize(report_date: ,record: ,city: ,report_shop_activities: )
    self.record = record
    self.city = city
    self.report_shop_activities = report_shop_activities

    self.date = record.report_date
  end

  private
  def process
    @result = calculate(report_shop_activities: report_shop_activities)

    record.assign_attributes(
      @result
    )
  end
  private
end