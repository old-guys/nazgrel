json.cache! ['api/channel/shopkeepers/profile', @shop.shopkeeper] do
  json.partial! 'api/channel/shopkeepers/profile', record: @shop.shopkeeper
end

# invite shopkeeper
json.child_count do
  json.count record.children_size
  json.grade_platinum_count record.children_grade_platinum_size
  json.grade_gold_count record.children_grade_gold_size
end
json.indirectly_descendant_count do
  json.count record.indirectly_descendant_size
  json.grade_platinum_count record.indirectly_descendant_grade_platinum_size
  json.grade_gold_count record.indirectly_descendant_grade_gold_size
end

# parent shopkeeper
json.parent({})
json.parent do
  if record.parent.present?
    json.cache! ['api/channel/shopkeepers/profile', record.parent] do
      json.partial! 'api/channel/shopkeepers/profile', record: record.parent
    end

    json.tree_list do
      json.cache_collection! record.parents.to_a, key: proc {|record| ['api/channel/shopkeepers/profile', record] } do |record|
        json.partial! 'api/channel/shopkeepers/profile',
          locals: {record: record}
      end
    end
  end
end

# income
# 账户总收入
json.total_income_amount record.total_income_amount
# 店铺佣金 店铺收益 销售佣金
json.commission_income_amount record.commission_income_amount

# 已提现金额
json.withdraw_amount record.withdraw_amount
# 冻结金额
# json.blocked_amount	record.blocked_amount

# 邀请总人数
json.invite_number record.invite_number
# 店铺佣金 店铺收益 销售佣金
json.commission_income_amount record.commission_income_amount
# 团队收益
json.team_income_amount record.team_income_amount
# 邀请收入 培训奖励
json.invite_amount record.invite_amount
# 销售业绩
json.shop_sales_amount record.shop_sales_amount
# 订单金额
json.order_amount	record.order_amount

# 数据统计
# 订单总数
json.order_number record.order_number
# 分享次数
json.share_journal_count record.share_journal_count
# 访问次数
json.view_journal_count record.view_journal_count