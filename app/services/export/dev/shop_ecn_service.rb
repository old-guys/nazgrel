class Export::Dev::ShopEcnService
  include Export::BaseService

  def report_fields
    %w(
      id shop.to_s shopkeeper.to_s channel.to_s
      shopkeeper.province shopkeeper.city
      shopkeeper.created_at shopkeeper.user_grade_i18n
      ecn_count ancestry_rate ecn_grade_platinum_count
      ecn_grade_gold_count
      children_count children_grade_platinum_count children_grade_gold_count
      indirectly_descendant_count indirectly_descendant_grade_platinum_count
      indirectly_descendant_grade_gold_count
    )
  end

  def report_head_names
    %w(
      # 店铺名称 店主姓名 渠道 省份
      城市 创建时间 店铺等级 ECN数 上级总数占比
      ECN白金数 ECN黄金数
      直接邀请数 直接ECN白金数 直接ECN黄金数
      间接邀请数 间接ECN白金数 间接ECN黄金数
    )
  end
end