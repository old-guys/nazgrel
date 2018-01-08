records = records.unscope(
  :limit, :offset
)

json.summary do
  json.cache! ['api/web/report/channel_shop_activities/time_type_month_summary', records] do
    ReportChannelShopActivity.stat_categories.each {|field|
      json.set!("stage_1_#{field}", records.sum("stage_1_#{field}").values.sum)
      json.set!("stage_2_#{field}", records.sum("stage_2_#{field}").values.sum)
      json.set!("stage_3_#{field}", records.sum("stage_3_#{field}").values.sum)
      json.set!("month_#{field}", records.pluck("max(month_#{field})").sum)
      json.set!("year_#{field}", records.pluck("max(month_#{field})").sum)
    }
  end
end