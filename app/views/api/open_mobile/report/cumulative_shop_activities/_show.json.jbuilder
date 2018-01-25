json.(record, :id, :shop_id)

_categories = %w(
  order_number shopkeeper_order_number sale_order_number
  order_amount shopkeeper_order_amount sale_order_amount
  children_grade_platinum_count children_grade_gold_count
  ecn_grade_platinum_count ecn_grade_gold_count
)

_stages = %w(day_0 day_7 day_30)
_categories.each {|category|
  _stages.each {|stage|
    json.(record, "#{stage}_#{category}")
  }
}

json.(record, :created_at, :updated_at)