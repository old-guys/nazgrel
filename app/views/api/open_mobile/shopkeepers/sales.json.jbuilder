json.partial! 'api/shared/paginator', records: @shopkeepers

json.cache! ['api/open/mobile/shopkeeper', @shopkeepers, expires_in: 10.minutes] do
  json.models do
    json.partial! 'api/open_mobile/shopkeepers/sales_show', collection: @shopkeepers, as: :record
  end
end