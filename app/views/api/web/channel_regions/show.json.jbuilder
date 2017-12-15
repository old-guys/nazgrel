json.partial! 'api/web/channel_regions/show', locals: { record: @channel_region }

json.channel_users([])
json.channel_users do
  if @channel_region.channel_users
    json.partial! 'api/web/channel_users/show', collection: @channel_region.channel_users, as: :record
  end
end

json.channel_region_maps([])
json.channel_region_maps do
  json.partial! 'api/web/channel_regions/channel_region_map', collection: @channel_region.channel_channel_region_maps, as: :record
end