class OrderExpressSeekWorker
  include Sidekiq::Worker
  sidekiq_options queue: :seek, retry: false, backtrace: true

  def perform
    SesameMall::OrderExpressSeek.partial_sync
  end

  def logger
    @logger ||= ActiveSupport::TaggedLogging.new(Logger.new("#{Rails.root}/log/seek.log", "weekly"))
  end

  private
end
