class Shopkeeper < ApplicationRecord
  include TreeDescendantable
  include OpenQueryable

  self.tree_depth = 100
  self.tree_primary_key = :user_id
  belongs_to :shop, required: false
  has_many :orders, through: :shop

  belongs_to :parent, primary_key: :user_id,
    foreign_key: :invite_user_id,
    class_name: :Shopkeeper, required: false

  has_many :income_records, foreign_key: :user_id

  attr_accessor :parents

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

  def parent_ids
    path.to_s.split("/").slice(1..-1)
  end

  def parents
    @parents ||= proc {
      _user_ids = parent_ids
      _records = self_and_ancestor_entities

      _user_ids.map{|user_id|
        _records.find{|record| record.user_id.to_s == user_id}
      }
    }.call
  end

  def province
    set_phone_belong_to if super.blank? and user_phone.present?

    super
  end

  private
  def set_phone_belong_to
    if user_phone.present?
      _hash = phone_belong_to_juhe_hash phone: user_phone
      return if _hash.blank?
      _hash["city"] = _hash["province"] if _hash["city"].blank?

      update_columns(
        city: _hash["city"],
        province: _hash["province"],
      )
    end
  end

  class << self
    def with_preload_parents(records: )
      _shopkeepers = Shopkeeper.where(
        user_id: records.compact.map(&:parent_ids).flatten.uniq
      )

      records.each {|record|
        record.parents = _shopkeepers.select{|shopkeeper|
          shopkeeper.user_id.to_s.in?(record.parent_ids)
        }
      }

      records
    end
  end
end