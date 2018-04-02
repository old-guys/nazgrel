module ChannelShopActivity::Calculations
  extend ActiveSupport::Concern

  included do
    delegate :sum_fields, to: "self.class"
  end

  def calculate(report_shop_activities: )
    format_calculate_hash(
      result: report_shop_activities.pluck_h(
        *sum_fields
      ).pop
    )
  end

  private
  module ClassMethods
    def sum_fields
      @sum_fields ||= ReportChannelShopActivity.stat_fields.map {|field|
        Arel.sql("sum(`report_shop_activities`.`#{field}`) as #{field}")
      }.freeze
    end
  end
end