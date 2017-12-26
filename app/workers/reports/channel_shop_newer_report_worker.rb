class ChannelShopNewerReportWorker
  include Sidekiq::Worker
  include ReportWorkable

  sidekiq_options queue: :report, retry: false, backtrace: true

  def perform(*args)
    logger.info "start: args #{args}"
    options = args.extract_options!
    _type = options["type"] || "partial"
    channels = case _type
      when "whole"
        Channel.normal
      when "partial"
        _key = ChannelShopNewer::UpdateReport::CHANNEL_IDS_CACHE_KEY

        Channel.where(id: $redis.SPOP(_key, 50))
    end

    ChannelShopNewer::UpdateReport.update_report(
      channels: channels
    )

    logger.info "finished"
  end

  private
end