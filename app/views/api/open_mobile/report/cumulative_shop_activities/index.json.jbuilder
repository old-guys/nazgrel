json.partial! 'api/shared/paginator', records: @report_cumulative_shop_activities

json.cache! ['api/open_mobile/report/cumulative_shop_activities', @report_cumulative_shop_activities] do
  json.models do
    json.cache_collection! @report_cumulative_shop_activities.to_a, key: 'api/open_mobile/report/cumulative_shop_activities/show' do |record|
      json.partial! 'api/open_mobile/report/cumulative_shop_activities/show',
        locals: {record: record}
    end
  end
end