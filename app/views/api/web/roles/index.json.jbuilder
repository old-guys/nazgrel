json.partial! 'api/shared/paginator', records: @roles

json.cache! ['api/web/roles', @roles] do
  json.models do
    json.cache_collection! @roles.to_a, key: 'api/web/roles/show' do |record|
      json.partial! 'api/web/roles/show',
        locals: {record: record}
    end
  end
end