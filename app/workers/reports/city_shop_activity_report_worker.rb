class CityShopActivityReportWorker
  include Sidekiq::Worker
  include ReportWorkable

  sidekiq_options queue: :report, retry: false, backtrace: true

  def perform(*args)
    logger.info "start: args #{args}"
    options = args.extract_options!
    _type = options["type"] || "partial"
    case _type
      when "whole"
        _cities = Shopkeeper.where.not(city: nil).pluck("distinct(city)")

        _cities.each_slice(500) {|cities|
          CityShopActivity::UpdateReport.update_report(
            city: cities,
            interval_time: 8.hours
          )
        }
      when "partial"
        _key = CityShopActivity::UpdateReport::CITY_CACHE_KEY

        # FIXME SPOP not accept count argument for redis < 3.2
        # _cities = $redis.SPOP(_key, 100)
        _cities = $redis.SMEMBERS(_key)
        $redis.DEL(_key) if _cities.present?

        _cities.each_slice(500) {|cities|
          CityShopActivity::UpdateReport.update_report(
            city: cities,
            interval_time: 5.minutes
          )
        }
    end

    logger.info "finished"
  end

  private
end