json.name @channel_user.name
json.shop_name @channel_user.own_shop.to_s

json.channel do
  if @channel_user.channel
    json.id @channel_user.channel_id
    json.name @channel_user.channel.name
    json.category @channel_user.channel.category
    json.category_text @channel_user.channel.category_i18n
    json.source @channel_user.channel.source
    json.source_text @channel_user.channel.source_i18n
  end
end

json.shopkeeper_user_id @channel_user.shopkeeper_user_id
json.shop_id @channel_user.shop_id

json.shopkeeper do
  if @channel_user.own_shopkeeper
    json.partial! 'api/channel/shopkeepers/profile', record: @channel_user.own_shopkeeper
  end
end

# 奖励
json.reward do
  # 培训奖励
  json.invite_children_reward_amount @channel_user.invite_children_reward_amount
  # 团队佣金
  json.children_comission_amount @channel_user.children_comission_amount
  # 奖励提成
  json.invite_children_amount @channel_user.invite_children_amount
  # 佣金提成
  json.indirectly_descendant_amount @channel_user.indirectly_descendant_amount
end
