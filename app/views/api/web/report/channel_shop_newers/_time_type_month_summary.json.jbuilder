records = records.unscope(
  :limit, :offset
)

json.summary do
  json.cache! ['api/web/report/channel_shop_newers/time_type_month_summary', records] do
    json.stage_1_grade_platinum records.sum(:stage_1_grade_platinum).values.sum
    json.stage_1_grade_gold records.sum(:stage_1_grade_gold).values.sum
    json.stage_2_grade_platinum records.sum(:stage_2_grade_platinum).values.sum
    json.stage_2_grade_gold records.sum(:stage_2_grade_gold).values.sum
    json.stage_3_grade_platinum records.sum(:stage_3_grade_platinum).values.sum
    json.stage_3_grade_gold records.sum(:stage_3_grade_gold).values.sum
    json.month_grade_platinum records.pluck("max(month_grade_platinum)").sum
    json.month_grade_gold records.pluck("max(month_grade_gold)").sum
    json.year_grade_platinum records.pluck("max(year_grade_platinum)").sum
    json.year_grade_gold records.pluck("max(year_grade_gold)").sum
  end
end