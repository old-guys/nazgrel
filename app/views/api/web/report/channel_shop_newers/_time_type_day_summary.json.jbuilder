records = records.unscope(
  :limit, :offset
)

json.summary do
  json.cache! ['api/web/report/channel_shop_newers/time_type_day_summary', records, expires_in: 10.minutes] do
    json.stage_1_grade_platinum records.sum(:stage_1_grade_platinum)
    json.stage_1_grade_gold records.sum(:stage_1_grade_gold)
    json.stage_2_grade_platinum records.sum(:stage_2_grade_platinum)
    json.stage_2_grade_gold records.sum(:stage_2_grade_gold)
    json.stage_3_grade_platinum records.sum(:stage_3_grade_platinum)
    json.stage_3_grade_gold records.sum(:stage_3_grade_gold)
    json.month_grade_platinum records.sum(:month_grade_platinum)
    json.month_grade_gold records.sum(:month_grade_gold)
    json.year_grade_platinum records.sum(:year_grade_platinum)
    json.year_grade_gold records.sum(:year_grade_gold)
  end
end