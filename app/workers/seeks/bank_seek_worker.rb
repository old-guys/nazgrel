class BankSeekWorker
  include Sidekiq::Worker
  include SeekWorkable

  sidekiq_options queue: :seek, retry: false, backtrace: true

  def perform(*args)
    logger.info "start: args #{args}"

    SesameMall::BankSeek.whole_sync

    logger.info "finished"
  end

end