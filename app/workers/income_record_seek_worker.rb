class IncomeRecordSeekWorker
  include Sidekiq::Worker
  sidekiq_options queue: :seek, retry: false, backtrace: true

  def perform
    SesameMall::IncomeRecordSeek.partial_sync
  end

  def logger
    @logger ||= ActiveSupport::TaggedLogging.new(Logger.new("#{Rails.root}/log/seek.log", "weekly"))
  end

  private
end
