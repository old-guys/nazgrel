module ChannelShopActivity::Calculations

  def calculate(report_shop_activities: )
    _sum_fields = stat_fields.map {|field|
      "sum(`report_shop_activities`.`#{field}`) as #{field}"
    }

    report_shop_activities.pluck_h(
      *_sum_fields
    ).pop
  end

  private
  def stat_fields
    %w{
        shared_count stage_1_shared_count stage_2_shared_count
        stage_3_shared_count month_shared_count year_shared_count
        view_count stage_1_view_count stage_2_view_count
        stage_3_view_count month_view_count year_view_count
        order_number stage_1_order_number stage_2_order_number
        stage_3_order_number month_order_number year_order_number
        shopkeeper_order_number stage_1_shopkeeper_order_number
        stage_2_shopkeeper_order_number stage_3_shopkeeper_order_number
        month_shopkeeper_order_number year_shopkeeper_order_number
        sale_order_number stage_1_sale_order_number stage_2_sale_order_number
        stage_3_sale_order_number month_sale_order_number year_sale_order_number
        order_amount stage_1_order_amount stage_2_order_amount
        stage_3_order_amount month_order_amount year_order_amount
        shopkeeper_order_amount stage_1_shopkeeper_order_amount
        stage_2_shopkeeper_order_amount stage_3_shopkeeper_order_amount
        month_shopkeeper_order_amount year_shopkeeper_order_amount
        sale_order_amount stage_1_sale_order_amount stage_2_sale_order_amount
        stage_3_sale_order_amount month_sale_order_amount year_sale_order_amount
        children_grade_platinum_count stage_1_children_grade_platinum_count
        stage_2_children_grade_platinum_count stage_3_children_grade_platinum_count
        month_children_grade_platinum_count year_children_grade_platinum_count
        children_grade_gold_count stage_1_children_grade_gold_count
        stage_2_children_grade_gold_count stage_3_children_grade_gold_count
        month_children_grade_gold_count year_children_grade_gold_count
        ecn_grade_platinum_count stage_1_ecn_grade_platinum_count
        stage_2_ecn_grade_platinum_count stage_3_ecn_grade_platinum_count
        month_ecn_grade_platinum_count year_ecn_grade_platinum_count
        ecn_grade_gold_count stage_1_ecn_grade_gold_count
        stage_2_ecn_grade_gold_count stage_3_ecn_grade_gold_count
        month_ecn_grade_gold_count year_ecn_grade_gold_count
    }.freeze
  end
end