json.partial! 'api/web/channel_regions/show', locals: { record: @channel_region }

json.channel_users([])
json.channel_users do
  json.cache_collection! @channel_region.channel_users.to_a, key: 'api/web/channel_users/show' do |record|
    json.partial! 'api/web/channel_users/show', locals: {record: record}
  end
end

json.channel_region_maps([])
json.channel_region_maps do
  json.cache_collection! @channel_region.channel_channel_region_maps.to_a, key: proc {|record|
    _channel =  record.channel

    [
      'api/web/channel_regions',
      [
        _channel,
        _channel.channel_users.select{|u| u.manager? or u.region_manager?}.pop
      ].flatten
    ]
  } do |record|
    json.partial! 'api/web/channel_regions/channel_region_map', locals: {record: record}
  end
end