record = @shop.shopkeeper

json.cache! ['api/zmall/mobile/shops/summary', record, record.report_cumulative_shop_activity] do
  json.id @shop.id

  json.(record, :order_amount,
    :commission_income_amount,
    :total_income_coin
  )

  json.shop_stat do
    json.(record,
      :children_grade_trainee_size,
      :children_activation_grade_trainee_size,
      :children_inactivated_grade_trainee_size,
      :children_grade_gold_size,
      :children_grade_platinum_size,
      :children_size
    )
    json.(record,
      :descendant_grade_trainee_size,
      :descendant_activation_grade_trainee_size,
      :descendant_inactivated_grade_trainee_size,
      :descendant_grade_gold_size,
      :descendant_grade_platinum_size,
      :descendant_size
    )
  end
end