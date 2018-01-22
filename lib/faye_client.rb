class FayeClient
  class << self
    def send_message(channel, params)
      message = {channel: channel, data: params}

      FayePushWorker.new.perform(message.to_json)
    end

    def pool
      $http_pool ||= ConnectionPool.new(size: 5, timeout: 5) { HTTParty }
    end
  end

end

# sample
# FayeClient.send_message("/notifications/broadcast", {text: "niday2323e"})