class Shopkeeper < ApplicationRecord
  include TreeDescendantable
  self.tree_depth = 100
  self.tree_primary_key = :user_id
  belongs_to :shop, required: false
  has_many :orders, through: :shop

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

  def order_total_price
    Rails.cache.fetch("shopkeeper:#{id}:order_total_price:raw", raw: true, expires_in: 30.minutes) {
      orders.sales_order.sum(:total_price)
    }
  end

  def commission_income_amount
    Rails.cache.fetch("shopkeeper:#{id}:commission_income_amount:raw", raw: true, expires_in: 30.minutes) {
      orders.sales_order.valided_order.sum(:comm)
    }
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