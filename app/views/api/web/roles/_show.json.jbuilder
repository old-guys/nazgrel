json.extract! record, :id, :name

json.cache! ['api/web/roles/show/permissions', record.permissions] do
  json.permissions do
    json.cache_collection! record.permissions, key: 'api/web/permissions/show' do |record|
      json.partial! 'api/web/permissions/show',
        locals: {record: record}
    end
  end
end

json.extract! record, :created_at, :updated_at