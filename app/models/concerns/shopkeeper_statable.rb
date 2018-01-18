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
      _records = ReportShopActivity.where(
        report_date: dates
      )
      if records.where_sql.present?
        _records = _records.where(shop_id: records.select(:shop_id))
      end

      _records.group(:shop_id).order(
        "sum(`order_amount`) desc"
        ).limit(limit).pluck_s(
          "`shop_id` as shop_id",
          "sum(`order_amount`) as amount"
        )
    end

    def view_count_rank(records: , dates: , limit: 10)
      _records = ViewJournal.where(
        created_at: dates
      )
      if records.where_sql.present?
        _records = _records.where(shop_id: records.select(:shop_id))
      end

      _records.group(:shop_id).order(
        "count(`shop_id`) desc"
        ).limit(limit).pluck_s(
          "`shop_id` as shop_id",
          "count(`shop_id`) as count"
        )
    end

    def shop_view_type_count(shop_id: , dates: , limit: 10)
      _records = ViewJournal.where(
        created_at: dates
      )
      if records.where_sql.present?
        _records = _records.where(shop_id: records.select(:shop_id))
      end

      _records.group(:type).order(
        "count(`type`) desc"
      ).limit(limit).count
    end

    def shop_shared_type_count(shop_id: , dates: , limit: 10)
      _records = ShareJournal.where(
        created_at: dates
      )
      if records.where_sql.present?
        _records = _records.where(shop_id: records.select(:shop_id))
      end

      _records.group(:type).order(
        "count(`type`) desc"
      ).limit(limit).count
    end

    def viewer_count_rank(records: , dates: , limit: 10)
      _records = ViewJournal.where(
        created_at: dates
      )
      if records.where_sql.present?
        _records = _records.where(shop_id: records.select(:shop_id))
      end

      _records.group(:shop_id).order(
        "count(distinct(`viewer_id`)) desc"
        ).limit(limit).pluck_s(
          "`shop_id` as shop_id",
          "count(distinct(`viewer_id`)) as count"
        )
    end

    def share_count_rank(records: , dates: , limit: 10)
      _records = ShareJournal.where(
        created_at: dates
      )
      if records.where_sql.present?
        _records = _records.where(shop_id: records.select(:shop_id))
      end

      _records.group(:shop_id).order(
        "count(`shop_id`) desc"
        ).limit(limit).pluck_s(
          "`shop_id` as shop_id",
          "count(`shop_id`) as count"
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