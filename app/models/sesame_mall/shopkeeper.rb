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
  include Searchable

  simple_search_on fields: [
    :name,
    "shopkeepers.user_name",
    "shopkeepers.user_phone"
  ], joins: :shop

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