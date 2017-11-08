ActiveSupport::Notifications.subscribe "sql.active_record" do |name, start, finish, id, payload|
  duration = (finish - start) * 1000

  if SERVICES_CONFIG[:log_active_record]
    logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new("#{Rails.root}/log/active_record.log", "weekly"))

    if duration >= 1
      logger.tagged(Time.now.strftime('%Y-%m-%d %H:%M:%S.%L'), id) {
        logger.info "#{payload[:name]} (#{duration.to_i}ms): #{payload[:sql]}"
      }
    end
  end

  if SERVICES_CONFIG[:log_active_record_slow]
    slow_logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new("#{Rails.root}/log/active_record-slow.log", "weekly"))

    if duration > (SERVICES_CONFIG[:log_active_record_slow] || 5000)
      slow_logger.tagged(Time.now.strftime('%Y-%m-%d %H:%M:%S.%L'), id) {
        slow_logger.info "#{payload[:name]} (#{duration.to_i}ms): #{payload[:sql]}"
      }
    end
  end
end
