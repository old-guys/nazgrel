json.partial! 'api/shared/paginator', records: @channel_users
json.models @channel_users do |record|
  json.partial! 'api/web/channel_users/show', locals: { record: record }
end
