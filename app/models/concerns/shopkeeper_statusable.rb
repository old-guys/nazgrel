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

  def children_grade_platinum_size
    Rails.cache.fetch("shopkeeper:#{cache_key}:children_grade_platinum_size", raw: true, expires_in: 10.minutes) {
      children.grade_platinum.size
    }.to_i
  end

  def children_grade_gold_size
    Rails.cache.fetch("shopkeeper:#{cache_key}:children_grade_gold_size", raw: true, expires_in: 10.minutes) {
      children.grade_gold.size
    }.to_i
  end

  module ClassMethods
  end
end