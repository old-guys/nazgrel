json.partial! 'api/shared/paginator', records: @report_shop_activities

json.cache! ['api/open_mobile/report/shop_activities', @report_shop_activities] do
  json.models do
    json.cache_collection! @report_shop_activities.to_a, key: 'api/open_mobile/report/shop_activities/show' do |record|
      json.partial! 'api/open_mobile/report/shop_activities/show',
        locals: {record: record}
    end
  end
end