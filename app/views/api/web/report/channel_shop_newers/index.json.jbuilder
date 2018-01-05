json.partial! 'api/shared/paginator', records: @records

json.cache! ['api/web/report/channel_shop_newers', @records] do
  json.models do
    json.cache_collection! @records.map.with_index(1).to_a, key: proc {|record, index|
        ['api/web/report/channel_shop_newers/show', [record, record.channel]]
      } do |record, index|
      json.partial! 'api/web/report/channel_shop_newers/show',
        locals: {record: record, index: index}
    end
  end
end