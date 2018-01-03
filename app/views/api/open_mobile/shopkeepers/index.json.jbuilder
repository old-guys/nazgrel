json.partial! 'api/shared/paginator', records: @shopkeepers

json.cache! ['api/open/mobile/shopkeeper', @shopkeepers] do
  report_shop_activities = ReportShopActivity.where(
    shop_id: @shopkeepers.pluck(:shop_id),
    report_date: Date.today
  )
  json.models do
    json.partial! 'api/open_mobile/shopkeepers/show',
      collection: @shopkeepers,
      as: :record, locals: {
        report_records: report_shop_activities
      }
  end
end