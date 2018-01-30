class ExportWorker
  include Sidekiq::Worker
  include ExportLoggerable

  sidekiq_options queue: :default, retry: false, backtrace: true

  def perform(opts = {})
    logger.info "start: opts #{opts}"

    opts = HashWithIndifferentAccess.new(opts)
    return unless opts[:service].in?(Export::BaseService.services)

    user = User.find_by(id: opts[:user_id])
    return unless user

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