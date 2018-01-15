module ShopkeeperStatusable
  extend ActiveSupport::Concern

  included do
    before_save do
      if path_changed?
        keys = parents.compact.map {|record|
          id = record.id
          [
            "shopkeeper:#{id}:descendant_size",
            "shopkeeper:#{id}:descendant_grade_platinum_size",
            "shopkeeper:#{id}:descendant_grade_gold_size",
            "shopkeeper:#{id}:children_size",
            "shopkeeper:#{id}:children_grade_platinum_size",
            "shopkeeper:#{id}:children_grade_gold_size"
          ]
        }.flatten

        Rails.cache.with {|c|
          c.del(keys)
        } if keys.present?
      end
    end
  end

  def share_journal_count
    Rails.cache.fetch("shopkeeper:#{id}:shop_count:raw", raw: true, expires_in: 30.minutes) {
      ShareJournal.where(shop_id: shop_id).count
    }.to_i
  end

  def view_journal_count
    Rails.cache.fetch("shopkeeper:#{id}:view_journal_count:raw", raw: true, expires_in: 30.minutes) {
      ViewJournal.where(shop_id: shop_id).count
    }.to_i
  end

  def descendant_size
    @descendant_size ||= Rails.cache.fetch("shopkeeper:#{id}:descendant_size", raw: true) {
      descendant_entities.size
    }.to_i
  end

  def descendant_grade_platinum_size
    @descendant_grade_platinum_size ||= Rails.cache.fetch("shopkeeper:#{id}:descendant_grade_platinum_size", raw: true) {
      descendant_entities.grade_platinum.size
    }.to_i
  end

  def descendant_grade_gold_size
    @descendant_grade_gold_size ||= Rails.cache.fetch("shopkeeper:#{id}:descendant_grade_gold_size", raw: true) {
      descendant_entities.grade_gold.size
    }.to_i
  end

  def children_size
    @children_size ||= Rails.cache.fetch("shopkeeper:#{id}:children_size", raw: true) {
      children.size
    }.to_i
  end

  def children_grade_platinum_size
    @children_grade_platinum_size ||= Rails.cache.fetch("shopkeeper:#{id}:children_grade_platinum_size", raw: true) {
      children.grade_platinum.size
    }.to_i
  end

  def children_grade_gold_size
    @children_grade_gold_size ||= Rails.cache.fetch("shopkeeper:#{id}:children_grade_gold_size", raw: true) {
      children.grade_gold.size
    }.to_i
  end

  def indirectly_descendant_size
    @indirectly_descendant_size ||= descendant_size - children_size
  end

  def indirectly_descendant_grade_platinum_size
    @indirectly_descendant_grade_platinum_size ||= descendant_grade_platinum_size - children_grade_platinum_size
  end

  def indirectly_descendant_grade_gold_size
    @indirectly_descendant_grade_gold_size ||= descendant_grade_gold_size - children_grade_gold_size
  end

  def descendant_order_number
    Rails.cache.fetch("shopkeeper:#{id}:descendant_order_number", raw: true, expires_in: 1.hours) {
      descendant_entities.sum(:order_number)
    }.to_i
  end

  def descendant_order_amount
    Rails.cache.fetch("shopkeeper:#{id}:descendant_order_amount", raw: true, expires_in: 1.hours) {
      descendant_entities.sum(:order_amount)
    }
  end

  def descendant_commission_income_amount
    Rails.cache.fetch("shopkeeper:#{id}:descendant_commission_income_amount", raw: true, expires_in: 1.hours) {
      descendant_entities.sum(:commission_income_amount)
    }
  end

  module ClassMethods
  end
end