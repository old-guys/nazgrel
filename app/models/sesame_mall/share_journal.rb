class ShareJournal < ApplicationRecord
  self.inheritance_column = :sti_type

  belongs_to :shop, primary_key: :id,
    foreign_key: :shop_id,
    class_name: :Shop, required: false

  has_one :shopkeeper, through: :shop


  enum type: {
    wechat_friend: 0,
    app: 1,
    wechat_moment: 2,
    qq: 3,
    qq_zone: 4,
    sms: 5,
    qrcord: 6
  }

  enum share_type: {
    share_shop: 0,
    share_invite: 1
  }

  class << self
    def prune_old_records
      where("`created_at` <= ?", 24.months.ago).in_batches(of: 10000) {|records|
        records.delete_all

        sleep 0.5
      }
    end
  end
end