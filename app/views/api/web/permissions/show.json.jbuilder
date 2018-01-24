json.cache! ['api/web/permissions/show', @permission] do
  json.partial! "api/web/permissions/show", record: @permission, cached: true
end