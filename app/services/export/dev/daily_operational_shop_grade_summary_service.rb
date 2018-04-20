class Export::Dev::DailyOperationalShopGradeSummaryService
  include Export::BaseService

  def report_fields
    %w(
      id report_date
    ).concat(
      stat_fields(user_grade: params[:user_grade])
    )
  end

  def report_head_names
    %w(
      # 报表日期
    ).concat(
    stat_fields(user_grade: params[:user_grade]).map{|field|
      ReportDailyOperationalShopGradeSummary.human_attribute_name(field)
    })
  end

  private
  def stat_fields(user_grade: )
      Array.wrap(user_grade).map {|_user_grade|
        %W(
          total_#{_user_grade}_count
          #{_user_grade}_count
          activation_#{_user_grade}_count
          #{_user_grade}_order_number
          #{_user_grade}_order_amount
          #{_user_grade}_sale_order_number
          #{_user_grade}_sale_order_amount
          #{_user_grade}_shopkeeper_order_number
          #{_user_grade}_shopkeeper_order_amount
          #{_user_grade}_sale_order_amount_rate
          #{_user_grade}_shopkeeper_order_amount_rate
        )
      }.flatten
  end
end