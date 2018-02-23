module ShopkeeperStatusable
  extend ActiveSupport::Concern

  included do
    has_one :report_cumulative_shop_activity, through: :shop

    before_save do
      if path_changed? and parents
        _keys = parents.compact.flat_map(&:cache_status_keys)

        Rails.cache.with {|c|
          c.del(_keys)
        }
      end
    end

    def delete_cache_data
      Rails.cache.with {|c|
        c.del(cache_status_keys)
      }
    end

    def cache_status_keys
      [
        "shopkeeper:#{id}:descendant_size",
        "shopkeeper:#{id}:descendant_activation_size",
        "shopkeeper:#{id}:descendant_grade_platinum_size",
        "shopkeeper:#{id}:descendant_grade_gold_size",
        "shopkeeper:#{id}:children_size",
        "shopkeeper:#{id}:children_grade_platinum_size",
        "shopkeeper:#{id}:children_grade_gold_size"
      ].freeze
    end
  end

  def descendant_entities_cache_key
    @descendant_entities_cache_key ||= descendant_entities.cache_key
  end

  def share_journal_count
    Rails.cache.fetch("shopkeeper:#{id}:share_journal_count:raw", raw: true, expires_in: 30.minutes) {
      report_cumulative_shop_activity.try(:total_shared_count) || ShareJournal.where(shop_id: shop_id).count
    }.to_i
  end

  def view_journal_count
    Rails.cache.fetch("shopkeeper:#{id}:view_journal_count:raw", raw: true, expires_in: 30.minutes) {
      report_cumulative_shop_activity.try(:total_view_count) || ViewJournal.where(shop_id: shop_id).count
    }.to_i
  end

  def descendant_size
    @descendant_size ||= Rails.cache.fetch("shopkeeper:#{id}:descendant_size", raw: true) {
      descendant_entities.size
    }.to_i
  end

  def descendant_activation_size
    @descendant_activation_size ||= Rails.cache.fetch("shopkeeper:#{id}:descendant_activation_size", raw: true) {
      descendant_entities.where.not(order_number: nil).size
    }.to_i
  end

  def descendant_activation_rate
    if descendant_size.to_f > 0
      descendant_activation_size / descendant_size.to_f
    else
      nil
    end
  end

  def descendant_grade_platinum_size
    @descendant_grade_platinum_size ||= Rails.cache.fetch("shopkeeper:#{id}:descendant_grade_platinum_size", raw: true) {
      report_cumulative_shop_activity.try(:total_ecn_grade_platinum_count) || descendant_entities.grade_platinum.size
    }.to_i
  end

  def descendant_grade_gold_size
    @descendant_grade_gold_size ||= Rails.cache.fetch("shopkeeper:#{id}:descendant_grade_gold_size", raw: true) {
      report_cumulative_shop_activity.try(:total_ecn_grade_gold_count) || descendant_entities.grade_gold.size
    }.to_i
  end

  def children_size
    @children_size ||= Rails.cache.fetch("shopkeeper:#{id}:children_size", raw: true) {
      children.size
    }.to_i
  end

  def children_grade_platinum_size
    @children_grade_platinum_size ||= Rails.cache.fetch("shopkeeper:#{id}:children_grade_platinum_size", raw: true) {
      report_cumulative_shop_activity.try(:total_children_grade_platinum_count) || children.grade_platinum.size
    }.to_i
  end

  def children_grade_gold_size
    @children_grade_gold_size ||= Rails.cache.fetch("shopkeeper:#{id}:children_grade_gold_size", raw: true) {
      report_cumulative_shop_activity.try(:total_children_grade_gold_count) || children.grade_gold.size
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
    Rails.cache.fetch("shopkeeper:#{id}:#{descendant_entities_cache_key}:descendant_order_number", raw: true) {
      descendant_entities.sum(:order_number)
    }.to_i
  end

  def descendant_order_amount
    Rails.cache.fetch("shopkeeper:#{id}:#{descendant_entities_cache_key}:descendant_order_amount", raw: true) {
      descendant_entities.sum(:order_amount)
    }
  end

  def descendant_commission_income_amount
    Rails.cache.fetch("shopkeeper:#{id}:#{descendant_entities_cache_key}:descendant_commission_income_amount", raw: true) {
      descendant_entities.sum(:commission_income_amount)
    }
  end

  module ClassMethods
  end
end