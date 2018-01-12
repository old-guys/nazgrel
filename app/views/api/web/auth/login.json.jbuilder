json.(@user, :id, :email, :created_at, :updated_at, :user_token)

json.cache! ['api/web/auth/login/permissions', @user.permited_permissions] do
  json.permissions do
    json.cache_collection! @user.permited_permissions.to_a, key: 'api/web/auth/permission' do |record|
      json.partial! 'api/web/auth/permission',
        locals: {record: record}
    end
  end
end