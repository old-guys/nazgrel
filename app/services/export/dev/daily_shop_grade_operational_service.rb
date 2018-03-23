class Export::Dev::DailyShopGradeOperationalService
  include Export::BaseService

  def report_fields
    %w(
      id report_date
      grade_trainee_count activation_grade_trainee_count
      trainee_upgrade_gold_count trainee_upgrade_platinum_count
      gold_upgrade_platinum_count
      grade_gold_count grade_platinum_count
      shopkeeper_count
    )
  end

  def report_head_names
    %w(
      # 报表日期
      体验店主数 有效体验店主数
      体验升黄金 体验升白金
      黄金升白金
      黄金店主 白金店主
      新增店主数
    )
  end
end