json.id record.id
json.shop_id record.shop_id
json.shop_img_url record.shop_img_url

json.shop_name record.shop.to_s
json.shop_img_url record.shop_img_url
json.shopkeeper_name record.to_s

json.province record.province
json.city record.city

json.user_grade record.user_grade
json.user_grade_text record.user_grade_i18n

_report_record = report_records.find{|report_record|
  report_record.shop_id == record.shop_id
}
json.today_order_amount _report_record.try(:order_amount).to_f.to_s
json.today_order_number _report_record.try(:order_number).to_i

json.created_at record.created_at