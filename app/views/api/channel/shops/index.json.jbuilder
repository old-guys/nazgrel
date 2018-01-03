json.partial! 'api/shared/paginator', records: @shops

json.cache! ['api/channel/shops', @shops, expires_in: 30.minutes] do
  json.models do
    json.partial! 'api/channel/shops/show', collection: @shops, as: :record
  end
end