json.name @channel.name
json.category @channel.category
json.category_text @channel.category_i18n
json.source @channel.source
json.source_text @channel.source_i18n

json.shopkeeper_user_id @channel.shopkeeper_user_id
json.shop_id @channel.shop_id

json.shopkeeper do
  json.partial! 'api/channel/shopkeepers/profile', record: @channel.own_shopkeeper
end

# 奖励
json.reward do
  # 培训奖励
  json.invite_children_reward_amount @channel.invite_children_reward_amount
  # 团队佣金
  json.children_comission_amount @channel.children_comission_amount
  # 奖励提成
  json.invite_children_amount @channel.invite_children_amount
  # 佣金提成
  json.indirectly_descendant_amount @channel.indirectly_descendant_amount
end
