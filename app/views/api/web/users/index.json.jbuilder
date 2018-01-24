json.partial! 'api/shared/paginator', records: @users

json.cache! ['api/web/users', @users] do
  json.models do
    json.cache_collection! @users.to_a, key: 'api/web/users/show' do |record|
      json.partial! 'api/web/users/show',
        locals: {record: record}
    end
  end
end