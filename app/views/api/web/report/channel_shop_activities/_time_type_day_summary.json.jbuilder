records = records.unscope(
  :limit, :offset
)

json.summary do
  json.cache! ['api/web/report/channel_shop_activities/time_type_day_summary', records] do
    _categories = ReportChannelShopActivity.stat_categories.reject{|s|
      s.in?(
        %w(
          ecn_grade_platinum_count
          ecn_grade_gold_count
        )
      )
    }
    _categories.each {|field|
      json.set!("#{field}", records.sum("#{field}"))
      json.set!("stage_1_#{field}", records.sum("stage_1_#{field}"))
      json.set!("stage_2_#{field}", records.sum("stage_2_#{field}"))
      json.set!("stage_3_#{field}", records.sum("stage_3_#{field}"))
      json.set!("month_#{field}", records.sum("month_#{field}"))
      json.set!("year_#{field}", records.sum("year_#{field}"))
    }

    json.set!("ecn_count", records.sum("ecn_grade_gold_count") + records.sum("ecn_grade_platinum_count"))
  end
end