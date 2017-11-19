json.partial! 'api/shared/paginator', records: @shops
json.models @channels do |record|
  json.partial! 'api/web/channels/show', locals: { record: record }

  json.channel_user do
    if record.channel_user
      json.partial! 'api/web/channel_users/show', locals: { record: record.channel_user }
    end
  end
end
