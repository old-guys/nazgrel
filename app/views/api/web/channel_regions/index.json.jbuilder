json.partial! 'api/shared/paginator', records: @channel_regions
json.models @channel_regions do |record|
  json.partial! 'api/web/channel_regions/show', locals: { record: record }

  json.channel_users do
    json.partial! 'api/web/channel_users/show', collection: record.channel_users.take(1), as: :record
  end

  json.channel_region_maps do
    json.partial! 'api/web/channel_regions/channel_region_map', collection: record.channel_channel_region_maps.take(2), as: :record
  end
end