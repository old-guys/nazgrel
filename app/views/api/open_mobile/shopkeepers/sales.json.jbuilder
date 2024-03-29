json.partial! 'api/shared/paginator', records: @shopkeepers

json.cache_if! !params[:updated_at_range].presence, ['api/open_mobile/shopkeeper', @shopkeepers] do
  json.models do
    json.cache_collection! @shopkeepers.to_a, key: 'api/open_mobile/shopkeepers/sales_show' do |record|
      json.partial! 'api/open_mobile/shopkeepers/sales_show',
        locals: {record: record}
    end
  end
end