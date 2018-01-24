json.partial! 'api/shared/paginator', records: @channel_users
json.cache! ['api/web/channel_users', @channel_users] do
  json.models do
    json.cache_collection! @channel_users.to_a, key: 'api/web/shops/show' do |record|
      json.partial! 'api/web/channel_users/show',
        locals: {record: record}
    end
  end
end