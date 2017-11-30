json.id record.id
json.channel_id record.channel_id
json.channel_region_id record.channel_region_id

json.channel_users do
  if record.channel.try(:channel_users)
    json.partial! 'api/web/channel_users/show', collection: record.channel.try(:channel_users), as: :record
  end
end
