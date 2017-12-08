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

  module ClassMethods
  end
end