class Export::Dev::ShopService
  include Export::BaseService

  def report_fields
    %w(
      id name shopkeeper.user_name shopkeeper.province shopkeeper.city
      shopkeeper.created_at shopkeeper.user_grade_i18n
      shopkeeper.order_number shopkeeper.order_amount
      shopkeeper.shopkeeper_order_number shopkeeper.shopkeeper_order_amount
      shopkeeper.sale_order_number shopkeeper.sale_order_amount
      shopkeeper.commission_income_amount
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

  def report_head_names
    %w(
      id 店铺名称 店主姓名 省份 城市
      创建时间 店铺等级
      订单数 订单金额
      自购订单数 自购订单金额
      销售订单数 销售订单金额
      佣金金额
      招募铂金店主总数 招募黄金店主总数 邀请人姓名
      邀请人号码 上级店主
    )
  end
end