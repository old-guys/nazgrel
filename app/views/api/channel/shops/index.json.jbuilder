json.partial! 'api/shared/paginator', records: @shops
json.models @shops do |record|
  json.id record.id
  json.name record.to_s
  json.shopkeeper_name record.shopkeeper.to_s
  json.parent_shopkeeper_name record.shopkeeper.try(:parent).to_s
  json.child_count record.children.size
  json.indirectly_descendant record.indirectly_descendant_entities.size

  json.commission_amount record.income_records.commission_income.sum(:income_amount)
  json.created_at record.created_at
end
