class Shopkeeper < ApplicationRecord
  include TreeDescendantable
  self.tree_depth = 100
  self.tree_primary_key = :user_id
  belongs_to :shop, required: false

  belongs_to :parent, primary_key: :user_id,
    foreign_key: :invite_user_id,
    class_name: :Shopkeeper, required: false

  has_many :income_records, foreign_key: :user_id

  enum user_grade: {
    grade_platinum: 0,
    grade_gold: 1,
    grade_trainee: 2
  }

  include ShopkeeperStatusable


  def order_number
    Rails.cache.fetch("shopkeeper:#{id}:order_number:raw", raw: true, expires_in: 30.minutes) {
      _value = Order.where(shop_id: shop_id).sales_order.size
      update_columns(order_number: Order.where(shop_id: shop_id).sales_order.size)

      _value
    }.to_i
  end

  def order_total_price
    Rails.cache.fetch("shopkeeper:#{id}:order_total_price:raw", raw: true, expires_in: 30.minutes) {
      _value = Order.where(shop_id: shop_id).sales_order.sum(:total_price)
      _value
    }.to_i
  end

  def to_s
    user_name || id.to_s
  end

  def parents
    _user_ids = path.to_s.split("/")
    _records = self_and_ancestor_entities
    _user_ids.shift

    _user_ids.map{|user_id|
      _records.find{|record| record.user_id.to_s == user_id}
    }
  end
end
