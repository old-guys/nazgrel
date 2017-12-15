json.partial! 'api/channel/shopkeepers/profile', record: @shop.shopkeeper

# invite shopkeeper
json.child_count do
  json.count record.children.size
  json.grade_platinum_count record.children.grade_platinum.size
  json.grade_gold_count record.children.grade_gold.size
end
json.indirectly_descendant_count do
  json.count record.indirectly_descendants.size
  json.grade_platinum_count record.indirectly_descendants.grade_platinum.size
  json.grade_gold_count record.indirectly_descendants.grade_gold.size
end

# parent shopkeeper
json.parent {}
json.parent do
  if record.parent.present?
    json.partial! 'api/channel/shopkeepers/profile', record: record.parent

    json.tree_list do
      json.array! record.parents do |parent|
        json.partial! 'api/channel/shopkeepers/profile', record: parent
      end
    end
  end
end

# income
# 账户总收入
json.total_income_amount record.total_income_amount
# 店铺佣金
json.commission_income_amount record.commission_income_amount

# 已提现金额
json.withdraw_amount record.withdraw_amount
# 冻结金额
# json.blocked_amount	record.blocked_amount
# 邀请收入 培训奖励
json.invite_amount record.invite_amount
# 邀请总人数
json.invite_number record.invite_number
# 店铺收益
json.commission_income_income_amount record.income_records.commission_income.sum(:income_amount)
# 订单金额
json.order_amount	record.order_amount

# 数据统计
# 订单总数
json.order_number record.order_number
# 分享次数
json.share_journal_count record.share_journal_count
# 访问次数
json.view_journal_count record.view_journal_count