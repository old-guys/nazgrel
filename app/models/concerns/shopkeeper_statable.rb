module ShopkeeperStatable
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    def children_rank(records: , dates: , limit: 10)
      _records = records.where(
        created_at: dates
      )

      _records.group(:invite_user_id).order(
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

    def shop_view_type_count(shop_id: , dates: , limit: 10, min_daily_value: 100)
      _records = ViewJournal.where(
        created_at: dates
      )
      if records.where_sql.present?
        _records = _records.where(shop_id: records.select(:shop_id))
      end

      # while whole shops rank, set min daily value to match high value shop
      if records.where_sql.blank?
        _shop_ids = ReportShopActivity.where(
          report_date: dates
        ).where(
          "view_count >= ?", min_daily_value
        ).select(:shop_id)

        _records = _records.where(shop_id: _shop_ids)
      end

      _records.group(:type).order(
        "count(`type`) desc"
      ).limit(limit).count
    end

    def shop_shared_type_count(shop_id: , dates: , limit: 10, min_daily_value: 50)
      _records = ShareJournal.where(
        created_at: dates
      )
      if records.where_sql.present?
        _records = _records.where(shop_id: records.select(:shop_id))
      end

      # while whole shops rank, set min daily value to match high value shop
      if records.where_sql.blank?
        _shop_ids = ReportShopActivity.where(
          report_date: dates
        ).where(
          "shared_count >= ?", min_daily_value
        ).select(:shop_id)

        _records = _records.where(shop_id: _shop_ids)
      end

      _records.group(:type).order(
        "count(`type`) desc"
      ).limit(limit).count
    end

    def view_count_rank(records: , dates: , limit: 10, min_daily_value: 100)
      _records = ViewJournal.where(
        created_at: dates
      )
      if records.where_sql.present?
        _records = _records.where(shop_id: records.select(:shop_id))
      end

      # while whole shops rank, set min daily value to match high value shop
      if records.where_sql.blank?
        _shop_ids = ReportShopActivity.where(
          report_date: dates
        ).where(
          "view_count >= ?", min_daily_value
        ).select(:shop_id)

        _records = _records.where(shop_id: _shop_ids)
      end

      _records.group(:shop_id).order(
        "count(`shop_id`) desc"
        ).limit(limit).pluck_s(
          "`shop_id` as shop_id",
          "count(`shop_id`) as count"
        )
    end

    def viewer_count_rank(records: , dates: , limit: 10, min_daily_value: 100)
      _records = ViewJournal.where(
        created_at: dates
      )
      if records.where_sql.present?
        _records = _records.where(shop_id: records.select(:shop_id))
      end

      # while whole shops rank, set min daily value to match high value shop
      if records.where_sql.blank?
        _shop_ids = ReportShopActivity.where(
          report_date: dates
        ).where(
          "view_count >= ?", min_daily_value
        ).select(:shop_id)

        _records = _records.where(shop_id: _shop_ids)
      end

      _records.group(:shop_id).order(
        "count(distinct(`viewer_id`)) desc"
        ).limit(limit).pluck_s(
          "`shop_id` as shop_id",
          "count(distinct(`viewer_id`)) as count"
        )
    end

    def share_count_rank(records: , dates: , limit: 10, min_daily_value: 50)
      _records = ShareJournal.where(
        created_at: dates
      )
      if records.where_sql.present?
        _records = _records.where(shop_id: records.select(:shop_id))
      end

      # while whole shops rank, set min daily value to match high value shop
      if records.where_sql.blank?
        _shop_ids = ReportShopActivity.where(
          report_date: dates
        ).where(
          "shared_count >= ?", min_daily_value
        ).select(:shop_id)

        _records = _records.where(shop_id: _shop_ids)
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