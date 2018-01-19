json.extract! record, :id, :email, :phone

json.role_type record.role_type
json.role_type_text record.role_type_i18n

json.cache! ['api/web/users/show/roles', record.roles] do
  json.roles do
    json.cache_collection! record.roles, key: 'api/web/roles/show' do |record|
      json.id record.id
      json.name record.name
    end
  end
end

json.extract! record, :created_at, :updated_at