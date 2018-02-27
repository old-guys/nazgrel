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
        "#{status_cache_key}:descendant_size",
        "#{status_cache_key}:descendant_activation_size",
        "#{status_cache_key}:descendant_grade_platinum_size",
        "#{status_cache_key}:descendant_grade_gold_size",
        "#{status_cache_key}:children_size",
        "#{status_cache_key}:children_grade_platinum_size",
        "#{status_cache_key}:children_grade_gold_size"
      ].freeze
    end
  end

  def share_journal_count
    Rails.cache.fetch("#{status_cache_key}:share_journal_count:raw", raw: true, expires_in: 30.minutes) {
      report_cumulative_shop_activity.try(:total_shared_count) || ShareJournal.where(shop_id: shop_id).count
    }.to_i
  end

  def view_journal_count
    Rails.cache.fetch("#{status_cache_key}:view_journal_count:raw", raw: true, expires_in: 30.minutes) {
      report_cumulative_shop_activity.try(:total_view_count) || ViewJournal.where(shop_id: shop_id).count
    }.to_i
  end

  def descendant_size
    @descendant_size ||= Rails.cache.fetch("#{status_cache_key}:descendant_size", raw: true) {
      report_cumulative_shop_activity.try(:total_descendant_count) || descendant_entities.size
    }.to_i
  end

  def descendant_activation_size
    @descendant_activation_size ||= Rails.cache.fetch("#{status_cache_key}:descendant_activation_size", raw: true) {
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
    @descendant_grade_platinum_size ||= Rails.cache.fetch("#{status_cache_key}:descendant_grade_platinum_size", raw: true) {
      report_cumulative_shop_activity.try(:total_ecn_grade_platinum_count) || descendant_entities.grade_platinum.size
    }.to_i
  end

  def descendant_grade_gold_size
    @descendant_grade_gold_size ||= Rails.cache.fetch("#{status_cache_key}descendant_grade_gold_size", raw: true) {
      report_cumulative_shop_activity.try(:total_ecn_grade_gold_count) || descendant_entities.grade_gold.size
    }.to_i
  end

  def children_size
    @children_size ||= Rails.cache.fetch("#{status_cache_key}:children_size", raw: true) {
      report_cumulative_shop_activity.try(:total_children_count) || children.size
    }.to_i
  end

  def children_grade_platinum_size
    @children_grade_platinum_size ||= Rails.cache.fetch("#{status_cache_key}:children_grade_platinum_size", raw: true) {
      report_cumulative_shop_activity.try(:total_children_grade_platinum_count) || children.grade_platinum.size
    }.to_i
  end

  def children_grade_gold_size
    @children_grade_gold_size ||= Rails.cache.fetch("#{status_cache_key}:children_grade_gold_size", raw: true) {
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
    Rails.cache.fetch("#{status_cache_key}:descendant_order_number", raw: true) {
      report_cumulative_shop_activity.try(:total_descendant_order_number) || descendant_entities.sum(:order_number)
    }.to_i
  end

  def descendant_order_amount
    BigDecimal.new(Rails.cache.fetch("#{status_cache_key}:descendant_order_amount", raw: true) {
      report_cumulative_shop_activity.try(:total_descendant_order_amount) || descendant_entities.sum(:order_amount)
    })
  end

  def descendant_commission_income_amount
    BigDecimal.new(Rails.cache.fetch("#{status_cache_key}:descendant_commission_income_amount", raw: true) {
      report_cumulative_shop_activity.try(:total_descendant_commission_income_amount) || descendant_entities.sum(:commission_income_amount)
    })
  end

  private
  def status_cache_key
    @status_cache_key ||= ActiveSupport::Cache.expand_cache_key([cache_key, report_cumulative_shop_activity])
  end
  module ClassMethods
  end
end