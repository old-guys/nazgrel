json.cache! ['api/web/users/show', @user] do
  json.partial! "api/web/users/show", record: @user, cached: true
end