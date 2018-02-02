module ActionExportable

  extend ActiveSupport::Concern

  included do
  end

  def preload_export(service: , action: , relation: , user_id: nil, **options)
    return unless params[:action_type].eql?('export')
    relation.unscope!(:limit, :offset)

    async_client_id = SecureRandom.uuid
    cache_key       = "export_#{async_client_id}"

    Rails.cache.write(cache_key, relation, expires_in: 30.minutes)

    jid = ExportWorker.perform_async(
      service: service,
      cache_key: cache_key,
      user_id: user_id,
      async_client_id: async_client_id,
      action: action,
      params: options
    )

    return render json: {
      code: 0,
      data: {
        jid: jid,
        async_client_id: async_client_id
      }
    }
  end

end