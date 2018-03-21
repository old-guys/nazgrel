module ChannelShopActivity::Calculations

  def calculate(report_shop_activities: )
    _sum_fields = ReportChannelShopActivity.stat_fields.map {|field|
      Arel.sql("sum(`report_shop_activities`.`#{field}`) as #{field}")
    }

    format_calculate_hash(
      result: report_shop_activities.pluck_h(
        *_sum_fields
      ).pop
    )
  end
end