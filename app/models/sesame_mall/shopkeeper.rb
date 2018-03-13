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

  belongs_to :shop_user, primary_key: :user_id,
    foreign_key: :user_id,
    class_name: :ShopUser, required: false

  has_many :income_records, foreign_key: :user_id, primary_key: :user_id

  attr_accessor :parents

  enum user_grade: {
    grade_platinum: 0,
    grade_gold: 1,
    grade_trainee: 2
  }
  enum org_grade: {
    grade_platinum: 0,
    grade_gold: 1,
    grade_trainee: 2
  }, _prefix: true
  enum status: {
    normal: 0,
    locked: 1,
    was_invalid: 2,
    init: 3
  }
  enum ticket_send_flag: {
    yes: 1,
    no: 0
  }, _prefix: true

  include ShopkeeperStatusable
  include ShopkeeperStatable
  include Searchable

  simple_search_on fields: [
    :name,
    "shopkeepers.user_name",
    "shopkeepers.user_phone"
  ], joins: :shop

  delegate :shop_img_url, to: :shop, allow_nil: true

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

  def invite_qrcode_url
    if invite_qrcode_path
      "http://inte.ishanggang.com/#{invite_qrcode_path}"
    else
      nil
    end
  end

  def set_phone_belong_to
    if user_phone.present?
      _hash = phone_belong_to_juhe_hash phone: user_phone
      return if _hash.blank?
      _hash["city"] = _hash["province"] if _hash["city"].blank?

      assign_attributes(
        city: _hash["city"],
        province: _hash["province"],
      )
    end
  end

  private
  class << self
    def with_preload_parents(records: )
      _shopkeepers = Shopkeeper.where(
        user_id: records.compact.map(&:parent_ids).flatten.uniq
      )

      records.compact.each {|record|
        record.parents = record.parent_ids.map{|user_id|
          _shopkeepers.find{|shopkeeper| shopkeeper.user_id.to_s == user_id.to_s}
        }.compact
      }

      records
    end
  end
end