json.partial! 'api/shared/paginator', records: @shopkeepers

json.cache! ['api/open/mobile/shopkeeper', @shopkeepers, expires_in: 3.minutes] do
  json.models do
    json.partial! 'api/open_mobile/shopkeepers/show', collection: @shopkeepers, as: :record
  end
end