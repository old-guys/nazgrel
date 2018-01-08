json.partial! 'api/shared/paginator', records: @records

json.cache! ['api/web/report/channel_shop_activities', @records] do
  json.models do
    json.cache_collection! @records.map.with_index(1).to_a, key: proc {|record, index|
        ['api/web/report/channel_shop_activities/show', [record, record.channel]]
      } do |record, index|
      json.partial! 'api/web/report/channel_shop_activities/show',
        locals: {record: record, index: index}
    end
  end
end