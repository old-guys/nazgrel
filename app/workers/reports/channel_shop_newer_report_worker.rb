class ChannelShopNewerReportWorker
  include Sidekiq::Worker
  include ReportWorkable

  sidekiq_options queue: :report, retry: false, backtrace: true

  def perform(*args)
    logger.info "start: args #{args}"
    options = args.extract_options!
    _type = options["type"] || "partial"
    case _type
      when "whole"
        ChannelShopNewer::UpdateReport.update_report(
          channels: Channel.normal,
          interval_time: 8.hours
        )
      when "partial"
        _key = ChannelShopNewer::UpdateReport::CHANNEL_IDS_CACHE_KEY

        # FIXME SPOP not accept count argument for redis < 3.2
        # _ids = $redis.SPOP(_key, 100)
        _ids = $redis.SMEMBERS(_key)
        $redis.DEL(_key) if _ids.present?

        _ids.each_slice(500) {|ids|
          ChannelShopNewer::UpdateReport.update_report(
            channels: Channel.normal.where(id: ids)
          )
        }
    end

    logger.info "finished"
  end

  private
end