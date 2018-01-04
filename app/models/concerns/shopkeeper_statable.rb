module ShopkeeperStatable
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    def children_rank(records: , dates: , limit: 10)
      records.where(
        created_at: dates
      ).group(:invite_user_id).order(
        "count(`invite_user_id`) desc"
        ).limit(limit).pluck_s(
          "`invite_user_id` as user_id",
          "count(`invite_user_id`) as count"
        )
    end

    def order_amount_rank(records: , dates: , limit: 10)
      ReportShopActivity.where(
        shop_id: records.select(:shop_id),
        report_date: dates
      ).group(:shop_id).order(
        "sum(`order_amount`) desc"
        ).limit(limit).pluck_s(
          "`shop_id` as shop_id",
          "sum(`order_amount`) as amount"
        )
    end

    def city_rank(records: , dates: , limit: 10)
      records.where(
        created_at: dates
      ).where.not(city: "").
      group(:city).order("count(city) desc").
      limit(limit).pluck_s(
        "`city` as city",
        "count(`city`) as count"
      )
    end
  end
end