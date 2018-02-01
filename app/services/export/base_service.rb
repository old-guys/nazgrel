module Export
  module BaseService
    extend ActiveSupport::Concern

    included do
      # http://api.rubyonrails.org/classes/ActiveModel/Model.html
      include ActiveModel::Model

      attr_accessor :service, :action, :action_name
      attr_accessor :user_id
      attr_accessor :params
      attr_accessor :cache_key, :cache_query
      attr_accessor :collection
      attr_accessor :file_pathname, :qiniu_file_path
      attr_accessor :status, :async_client_id, :gap_progress, :progress

      include Export::Loggerable
      include Export::Messageable
      include Export::Processable

      def initialize(attributes={})
        super(attributes)

        self.action_name = self.class.action_map_names["#{service}##{action}"]
        self.params = (self.params || {}).with_indifferent_access

        self.max_size = 10000
        self.cache_query = Rails.cache.read(cache_key)
        self.collection = cache_query
      end
    end

    def validate?
      return true if cache_query.is_a?(ActiveRecord::Relation)

      self.status = :failure
      send_to_message
    end

    def perform
      process if validate?
    end

    def process
      build_file
      write_file
      upload_file_to_qiniu

      finally
    end

    private
    def upload_file_to_qiniu
      result = Qiniu.upload_file({
        uptoken: qiniu_upload_token,
        file: file_pathname,
        bucket: QINIU_CONFIG['bucket'],
        key: "tmp/#{async_client_id}/#{action_name}_#{Time.now.strftime('%Y%m%d')}.xlsx",
        mime_type: Rack::Mime.mime_type(File.extname(file_pathname))
      }) || {}

      logger.info "upload qiniu: result: #{result}"

      if result['key']
        assign_attributes(
          qiniu_file_path: "#{QINIU_CONFIG['host']}/#{result['key']}",
          status: :success,
          progress: 100
        )
        send_to_message
      else
        self.status    = :upload_failure
        send_to_message
      end
    end

    module ClassMethods
      def action_map_names
        {
          'ChannelShopNewer#report' => '渠道新增店主',
          'ChannelShopActivity#report' => '渠道店主行为',
          'ReportShopEcn#index' => '店主ECN',
          'Dev::Shop#report' => '导出新增',
        }.freeze
      end
    end
  end
end