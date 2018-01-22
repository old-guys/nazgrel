class FayePushWorker
  include Sidekiq::Worker

  sidekiq_options queue: :low, retry: true, backtrace: true

  def perform(message_json)
    logger.info "exec mq message: try exec faye_push for #{message_json}"
    uri = URI.parse("#{SERVICES_CONFIG["faye_push"]["host"]}/faye")

    FayeClient.pool.with do |conn|
      conn.post(uri, body: {message: message_json})
    end
  rescue => e
    logger.error "exec_sync exception: #{e.message}:#{e.backtrace}"
  end

  private
  def logger
    @logger ||= ActiveSupport::Logger.new("#{Rails.root}/log/faye_push.log", "weekly")
  end
end
