json.partial! 'api/shared/paginator', records: @report_cumulative_shop_activities

json.models do
  json.cache_collection! @report_cumulative_shop_activities.to_a, key: 'api/open_mobile/report/cumulative_shop_activities/show', expires_in: 1.hours do |record|
    json.partial! 'api/open_mobile/report/cumulative_shop_activities/show',
      locals: {record: record}
  end
end