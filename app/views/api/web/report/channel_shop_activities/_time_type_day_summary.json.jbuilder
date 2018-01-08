records = records.unscope(
  :limit, :offset
)

json.summary do
  json.cache! ['api/web/report/channel_shop_activities/time_type_day_summary', records] do
    ReportChannelShopActivity.stat_categories.each {|field|
      json.set!("stage_1_#{field}", records.sum("stage_1_#{field}"))
      json.set!("stage_2_#{field}", records.sum("stage_2_#{field}"))
      json.set!("stage_3_#{field}", records.sum("stage_3_#{field}"))
      json.set!("month_#{field}", records.sum("month_#{field}"))
      json.set!("year_#{field}", records.sum("year_#{field}"))
    }
  end
end