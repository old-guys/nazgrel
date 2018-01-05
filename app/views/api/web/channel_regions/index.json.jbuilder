json.partial! 'api/shared/paginator', records: @channel_regions
json.models do
  json.cache_collection! @channel_regions.to_a, key: proc {|record|
      [
        'api/web/channel_regions',
        [
          record,
          record.channel_users.take(1),
          record.channel_channel_region_maps.take(2).map{|_record|
            _channel =  _record.channel

            [
              _channel,
              _channel.channel_users.select{|u| u.manager? or u.region_manager?}.pop
            ]
          }
        ].flatten
      ]
    } do |record|
    json.partial! 'api/web/channel_regions/show', locals: { record: record }

    json.channel_users do
      json.partial! 'api/web/channel_users/show',
        collection: record.channel_users.take(1),
        as: :record
    end

    json.channel_region_maps do
      json.partial! 'api/web/channel_regions/channel_region_map',
        collection: record.channel_channel_region_maps.take(2),
        as: :record
    end
  end
end