json.partial! 'api/shared/paginator', records: @channels

json.cache! ['api/web/channels', @channels.map{|_record| [_record, _record.channel_users]}] do
  json.models do
    json.cache_collection! @channels.to_a, key: proc {|record|
      [
        'api/web/channels',
        [
          record,
          record.channel_users
        ].flatten
      ]
    } do |record|
      json.partial! 'api/web/channels/show', locals: { record: record }
      json.channel_users do
        json.partial! 'api/web/channel_users/show', collection: record.channel_users, as: :record
      end
    end
  end
end