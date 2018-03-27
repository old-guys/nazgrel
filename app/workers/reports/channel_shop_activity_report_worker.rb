class ChannelShopActivityReportWorker
  include Sidekiq::Worker
  include ReportWorkable

  sidekiq_options queue: :report, retry: false, backtrace: true

  def perform(*args)
    logger.info "start: args #{args}"
    options = args.extract_options!
    _type = options["type"] || "partial"
    case _type
      when "whole"
        _channels = Channel.normal

        _channels.each {|channel|
          ChannelShopActivity::UpdateReport.update_report(
            channel: channel,
            interval_time: 8.hours
          )
        }
      when "partial"
        _key = ChannelShopActivity::UpdateReport::CHANNEL_IDS_CACHE_KEY

        # FIXME SPOP not accept count argument for redis < 3.2
        # _channel_ids = $redis.SPOP(_key, 100)
        _channel_ids = $redis.SMEMBERS(_key)
        $redis.DEL(_key) if _channel_ids.present?

        Channel.normal.where(id: _channel_ids).each {|channel|
          ChannelShopActivity::UpdateReport.update_report(
            channel: channel
          )
        }
    end

    logger.info "finished"
  end

  private
end