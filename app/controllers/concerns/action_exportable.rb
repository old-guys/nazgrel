module ActionExportable

  extend ActiveSupport::Concern

  included do
  end

  def preload_export(service: nil, action: nil, relation: [], user: nil, **options)
    return unless params[:action_type].eql?('export')

    user            ||= current_user
    async_client_id ||= SecureRandom.uuid
    cache_key       ||= "export_#{current_user.id}_#{async_client_id}"
    relation        ||= relation.unscope(:limit, :offset)

    Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      relation
    end

    @jid = ExportWorker.perform_async({
      service: service,
      cache_key: cache_key,
      user_id: user.id,
      async_client_id: async_client_id,
      page: params[:page],
      action: action,
      **options
    })

    return render json: {
      code: 0,
      data: {
        jid: @jid,
        async_client_id: async_client_id
      }
    }
  end

end
