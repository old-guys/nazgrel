json.cache! ['api/web/roles/show', @role] do
  json.partial! "api/web/roles/show", record: @role
end