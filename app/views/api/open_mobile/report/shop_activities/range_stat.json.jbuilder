json.partial! 'api/shared/paginator', records: @report_shop_activities

json.models do
  json.cache_collection! @report_shop_activities.to_a, key: 'api/open_mobile/report/shop_activities/range_stat_show', expires_in: 1.days do |record|
    json.partial! 'api/open_mobile/report/shop_activities/range_stat_show',
      locals: {record: record}
  end
end