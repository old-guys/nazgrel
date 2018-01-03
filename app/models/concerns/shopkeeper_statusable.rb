module ShopkeeperStatusable
  extend ActiveSupport::Concern

  included do
  end

  def share_journal_count
    Rails.cache.fetch("channel:#{id}:shop_count:raw", raw: true, expires_in: 30.minutes) {
      SesameMall::Source::ShareJournal.where(shop_id: shop_id).count
    }.to_i
  end

  def view_journal_count
    Rails.cache.fetch("channel:#{id}:order_count:raw", raw: true, expires_in: 30.minutes) {
      SesameMall::Source::ViewJournal.where(shop_id: shop_id).count
    }.to_i
  end

  def descendant_size
    Rails.cache.fetch("shopkeeper:#{cache_key}:descendant_count", raw: true, expires_in: 30.minutes) {
      descendant_entities.size
    }.to_i
  end

  def children_size
    Rails.cache.fetch("shopkeeper:#{cache_key}:children_size", raw: true, expires_in: 30.minutes) {
      children.size
    }.to_i
  end

  def children_grade_platinum_size
    Rails.cache.fetch("shopkeeper:#{cache_key}:children_grade_platinum_size", raw: true, expires_in: 30.minutes) {
      children.grade_platinum.size
    }.to_i
  end

  def children_grade_gold_size
    Rails.cache.fetch("shopkeeper:#{cache_key}:children_grade_gold_size", raw: true, expires_in: 30.minutes) {
      children.grade_gold.size
    }.to_i
  end

  def descendant_order_number
    Rails.cache.fetch("shopkeeper:#{cache_key}:descendant_order_number", raw: true, expires_in: 1.hours) {
      descendant_entities.sum(:order_number)
    }.to_i
  end

  def descendant_order_amount
    Rails.cache.fetch("shopkeeper:#{cache_key}:descendant_order_amount", raw: true, expires_in: 1.hours) {
      descendant_entities.sum(:order_amount)
    }
  end

  module ClassMethods
  end
end