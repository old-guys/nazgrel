module Export::Messageable
  extend ActiveSupport::Concern

  included do
  end

  def send_to_message(params = {})
    _params = {
      status: status,
      qiniu_file_path: qiniu_file_path,
      progress: progress,
      service: service,
      async_client_id: async_client_id,
      gap_progress: gap_progress,
      count: total_count,
      action_name: action_name
    }.merge!(params)
    _params[:file_size] ||= file_pathname.exist? ? file_pathname.size : nil

    _faye_channel = self.class.faye_channel(user_id)
    logger.info "send_message: channel: #{_faye_channel} , params: #{_params}"
    FayeClient.send_message(_faye_channel, _params)
  end

  module ClassMethods
    def faye_channel(name)
      name ||= "default"

      "/export/file/#{name}"
    end
  end
end