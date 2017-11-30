json.partial! 'api/web/channels/show', locals: { record: @channel }

json.channel_users do
  json.partial! 'api/web/channel_users/show', collection: @channel.channel_users, as: :record
end
