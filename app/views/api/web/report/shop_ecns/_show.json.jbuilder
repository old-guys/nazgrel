_shopkeeper = record.shopkeeper
_ancestry_rate = record.ancestry_rate.blank? ? nil : number_to_percentage(record.ancestry_rate * 100, precision: 1)
json.id record.id
json.shop_id record.shop_id
json.shop_name record.shop.to_s

json.channel_id record.channel_id
json.channel_name record.channel.to_s

json.shopkeeper_user_id _shopkeeper.try(:user_id)
json.shopkeeper_name _shopkeeper.to_s
json.shopkeeper_phone _shopkeeper.try(:user_phone)

json.ecn_count record.ecn_count

json.ancestry_rate _ancestry_rate

json.(record, :ecn_grade_platinum_count, :ecn_grade_gold_count,
  :children_count, :children_grade_platinum_count,
  :children_grade_gold_count, :indirectly_descendant_count,
  :indirectly_descendant_grade_platinum_count,
  :indirectly_descendant_grade_gold_count
)