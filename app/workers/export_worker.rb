class ExportWorker
  include Sidekiq::Worker
  include Export::Loggerable

  sidekiq_options queue: :default, retry: false, backtrace: true

  def perform(opts = {})
    logger.info "start: opts #{opts}"
    opts = HashWithIndifferentAccess.new(opts)

    @service = "Export::#{opts[:service]}Service".constantize.new(opts)
    @service.perform
  rescue => e
    logger.error "#{e.message}"
    e.backtrace.each { |msg| logger.error msg }

    @service.send_to_message(opts.merge({status: 'failure', error_message: e.message}))
  ensure
    logger.info "finished"
  end

end