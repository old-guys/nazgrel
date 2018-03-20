json.partial! 'api/shared/paginator', records: @shopkeepers

json.cache_if! !params[:updated_at_range].presence, ['api/open_mobile/shopkeeper', @shopkeepers] do
  json.models do
    report_shop_activities = ReportShopActivity.where(
      shop_id: @shopkeepers.pluck(:shop_id),
      report_date: Date.today
    )

    json.cache_collection! @shopkeepers.to_a, key: 'api/open_mobile/shopkeepers' do |record|
      json.partial! 'api/open_mobile/shopkeepers/show',
        locals: {record: record, report_records: report_shop_activities}
    end
  end
end