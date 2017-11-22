json.partial! 'api/shared/paginator', records: @channels
json.models @channels do |record|
  json.partial! 'api/web/channels/show', locals: { record: record }

  json.channel_users do
    json.partial! 'api/web/channel_users/show', collection: record.channel_users, as: :record
  end
end
