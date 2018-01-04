json.id record.id
json.name record.to_s
json.shopkeeper_name record.shopkeeper.to_s
json.user_grade record.shopkeeper.user_grade
json.user_grade_text record.shopkeeper.user_grade_i18n

json.parent_shopkeeper_name record.shopkeeper.try(:parent).to_s
json.child_count record.shopkeeper.children_size
json.indirectly_descendant record.shopkeeper.indirectly_descendant_size

json.commission_amount record.shopkeeper.commission_income_amount
json.created_at record.created_at