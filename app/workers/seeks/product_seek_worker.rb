class ProductSeekWorker
  include Sidekiq::Worker
  include SeekWorkable

  sidekiq_options queue: :seek, retry: false, backtrace: true

  def perform(*args)
    logger.info "start: args #{args}"
    options = args.extract_options!
    _seek_options = extract_seek_options(options: options)

    SesameMall::ProductSeek.partial_sync(_seek_options)
    logger.info "finished"
  end

  private
end