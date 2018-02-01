class Export::Dev::ShopService
  include Export::BaseService

  def report_fields
    %w(
      id name shopkeeper.user_name shopkeeper.province shopkeeper.city
      shopkeeper.created_at shopkeeper.user_grade_i18n
      shopkeeper.order_amount shopkeeper.commission_income_amount
      shopkeeper.children_grade_platinum_size
      shopkeeper.children_grade_gold_size
      shopkeeper.parent.user_name shopkeeper.parent.user_phone
      shopkeeper_parents
    )
  end

  def report_record_shopkeeper_parents(record)
    return if record.shopkeeper.blank?

    record.shopkeeper.parents.map{|s|
      "#{s}(#{s.user_id})"
    }.join(" > ")
  end

    def write_report_head
      xlsx_package_wb.styles.add_style(bg_color: "996600", fg_color: "FFFFFF", sz: 14, format_code: "@",font_name: 'SimSun', alignment: {horizontal: :center})
      xlsx_package_ws.add_row %w(
        id 店铺名 店主姓名 省份 城市
        创建时间 店铺等级 销售业绩 佣金金额
        招募铂金店主总数 招募黄金店主总数 邀请人姓名
        邀请人号码 上级店主
      )
    end
end