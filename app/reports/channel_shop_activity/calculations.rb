module ChannelShopActivity::Calculations

  def calculate(report_shop_activities: )
    _sum_fields = ReportChannelShopActivity.stat_fields.map {|field|
      "sum(`report_shop_activities`.`#{field}`) as #{field}"
    }

    report_shop_activities.pluck_h(
      *_sum_fields
    ).pop.try(:reject){|_,v|
      v.blank?
    }
  end
end