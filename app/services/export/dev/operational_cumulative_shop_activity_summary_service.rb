class Export::Dev::OperationalCumulativeShopActivitySummaryService
  include Export::BaseService

  def report_fields
    %w(
      id report_date
      week_1_total_count month_1_total_count
      month_3_total_count month_6_total_count
      year_1_total_count
      week_1_grade_gold_count month_1_grade_gold_count
      month_3_grade_gold_count month_6_grade_gold_count
      year_1_grade_gold_count
      week_1_grade_platinum_count month_1_grade_platinum_count
      month_3_grade_platinum_count month_6_grade_platinum_count
      year_1_grade_platinum_count
      week_1_grade_trainee_count month_1_grade_trainee_count
      month_3_grade_trainee_count month_6_grade_trainee_count
      year_1_grade_trainee_count
    )
  end

  def report_head_names
    %w(
      # 报表日期
      1周总店主 1月总店主
      3月总店主 6月总店主
      1年总店主
      1周黄金店主 1月黄金店主
      3月黄金店主 6月黄金店主
      1年黄金店主
      1周白金店主 1月白金店主
      3月白金店主 6月白金店主
      1年白金店主
      1周体验店主 1月体验店主
      3月体验店主 6月体验店主
      1年体验店主
    )
  end
end