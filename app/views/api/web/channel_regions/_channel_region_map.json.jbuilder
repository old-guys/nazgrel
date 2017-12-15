json.id record.id
json.channel_id record.channel_id
json.channel_name record.channel.try(:name)
json.channel_region_id record.channel_region_id

json.channel {}
json.channel do
  if record.channel
    json.partial! 'api/web/channels/show', locals: { record: record.channel }
  end
end

json.channel_users []
json.channel_users do
  if record.channel.try(:channel_users)
    json.partial! 'api/web/channel_users/show', collection: record.channel.channel_users.select(&:manager?), as: :record
  end
end