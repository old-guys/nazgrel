json.partial! 'api/shared/paginator', records: @permissions

json.cache! ['api/web/permissions', @permissions] do
  json.models do
    json.cache_collection! @permissions.to_a, key: 'api/web/permissions/show' do |record|
      json.partial! 'api/web/permissions/show',
        locals: {record: record}
    end
  end
end