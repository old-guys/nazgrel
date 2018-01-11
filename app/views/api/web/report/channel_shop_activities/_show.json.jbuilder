json.index index

json.channel_id record.channel_id
json.channel({})
json.channel do
  json.name record.channel.to_s
  json.channel_user_name record.channel.channel_users.take.to_s
  json.city record.channel.city
end

json.(record,
  *ReportChannelShopActivity.stat_fields
)
json.ecn_count record.ecn_grade_platinum_count.to_i + record.ecn_grade_gold_count.to_i