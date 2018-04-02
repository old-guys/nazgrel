module CumulativeShopActivity::Calculations
  extend ActiveSupport::Concern

  included do
    delegate :sum_fields, :total_sum_fields, to: "self.class"
  end

  def calculate(shop_id: , date: )
    result = ReportCumulativeShopActivity.stat_cumulative_stages.each_with_object({}) {|stage, hash|
      _result = calculate_by_stage(stage: stage, shop_id: shop_id, date: date) || {}
      hash.merge!(_result)
    }

    _result = calculate_by_total(shop_id: shop_id, date: date) || {}
    result.merge!(
      _result
    )
  end

  private
  def calculate_by_stage(stage: , shop_id: , date:)
    dates = (stage.split("_").last.to_i).days.ago(date)..date

    format_calculate_hash(
      result: ReportShopActivity.where(
        report_date: dates,
        shop_id: shop_id
      ).pluck_h(*sum_fields(stage: stage)).pop
    )
  end

  def calculate_by_total(shop_id: , date:)
    format_calculate_hash(
      result: ReportShopActivity.where(
        report_date: date,
        shop_id: shop_id
      ).pluck_h(*total_sum_fields).pop
    )
  end
  private
  module ClassMethods
    def sum_fields(stage: )
      @sum_fields ||= {}

      @sum_fields[stage] ||= ReportCumulativeShopActivity.stat_categories.map {|field|
        Arel.sql("sum(`report_shop_activities`.`#{field}`) as #{stage}_#{field}")
      }.freeze
    end

    def total_sum_fields
      @total_sum_fields ||= ReportCumulativeShopActivity.stat_categories.map {|field|
        :"total_#{field}"
      }.freeze
    end
  end
end