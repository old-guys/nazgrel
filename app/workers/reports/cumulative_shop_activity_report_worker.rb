class CumulativeShopActivityReportWorker
  include Sidekiq::Worker
  include ReportWorkable

  sidekiq_options queue: :report, retry: false, backtrace: true

  def perform(*args)
    logger.info "start: args #{args}"
    options = args.extract_options!
    _type = options["type"] || "partial"
    case _type
      when "update_old"
        _stage = ReportCumulativeShopActivity.stat_cumulative_stages.last
        date = Date.yesterday
        dates = (_stage.split("_").last.to_i).days.ago(date)..date

        ReportCumulativeShopActivity.where(
          report_date: dates
        ).in_batches do |records|
          CumulativeShopActivity::UpdateReport.update_report(
            shops: Shop.where(id: records.select(:shop_id)),
            interval_time: 8.hours,
            touch_report_date: false
          )
        end
      when "partial"
        _key = CumulativeShopActivity::UpdateReport::SHOP_IDS_CACHE_KEY

        # FIXME SPOP not accept count argument for redis < 3.2
        # _ids = $redis.SPOP(_key, 100)
        _ids = $redis.SMEMBERS(_key)
        $redis.DEL(_key) if _ids.present?

        _ids.each_slice(500) {|ids|
          CumulativeShopActivity::UpdateReport.update_report(
            shops: Shop.where(id: _ids),
            touch_report_date: true
          )
        }
    end

    logger.info "finished"
  end

  private
end