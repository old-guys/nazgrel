records = records.unscope(
  :limit, :offset
)

json.summary do
  json.cache! ['api/web/report/channel_shop_activities/time_type_month_summary', records] do
    _categories = ReportChannelShopActivity.stat_categories.reject{|s|
      s.in?(
        %w(
          ecn_grade_platinum_count
          ecn_grade_gold_count
        )
      )
    }
    _categories.each {|field|
      json.set!("#{field}", records.sum("#{field}").values.sum)
      json.set!("stage_1_#{field}", records.sum("stage_1_#{field}").values.sum)
      json.set!("stage_2_#{field}", records.sum("stage_2_#{field}").values.sum)
      json.set!("stage_3_#{field}", records.sum("stage_3_#{field}").values.sum)
      json.set!("week_#{field}", records.pluck("max(week_#{field})").sum)
      json.set!("month_#{field}", records.pluck("max(month_#{field})").sum)
      json.set!("year_#{field}", records.pluck("max(month_#{field})").sum)
    }
    json.set!("ecn_count", records.pluck("max(ecn_grade_gold_count)").sum + records.pluck("max(ecn_grade_platinum_count)").sum)
  end
end