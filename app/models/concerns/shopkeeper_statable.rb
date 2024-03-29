module ShopkeeperStatable
  extend ActiveSupport::Concern

  included do
  end

  def seek_timestmap_service
    @seek_timestmap_service ||= SesameMall::ShopkeeperSeekTimestampService.new(
      shopkeeper: self
    )
  end

  module ClassMethods
    def children_rank(records: , dates: , limit: 10)
      _records = records.where(
        created_at: dates
      )

      _records.group(:invite_user_id).order(
        "count(`invite_user_id`) desc"
        ).limit(limit).pluck_s(
          Arel.sql("`invite_user_id` as user_id"),
          Arel.sql("count(`invite_user_id`) as count")
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
          Arel.sql("`shop_id` as shop_id"),
          Arel.sql("sum(`order_amount`) as amount")
        )
    end

    def shop_view_type_count(shop_id: , dates: , limit: 10, min_daily_value: 150)
      _records = ViewJournal.where(
        created_at: dates,
        shop_id: shop_id
      )

      _records.group(:type).order(
        "count(`type`) desc"
      ).limit(limit).count
    end

    def shop_shared_type_count(shop_id: , dates: , limit: 10, min_daily_value: 50)
      _records = ShareJournal.where(
        created_at: dates,
        shop_id: shop_id
      )

      _records.group(:type).order(
        "count(`type`) desc"
      ).limit(limit).count
    end

    def view_count_rank(records: , dates: , limit: 10, min_daily_value: 150)
      _records = ReportShopActivity.where(
        report_date: dates
      )
      if records.where_sql.present?
        _records = _records.where(shop_id: records.select(:shop_id))
      end

      _records.group(:shop_id).order(
        "sum(`view_count`) desc"
        ).limit(limit).pluck_s(
          Arel.sql("`shop_id` as shop_id"),
          Arel.sql("sum(`view_count`) as count")
        )
    end

    def viewer_count_rank(records: , dates: , limit: 10, min_daily_value: 150)
      # _records = ViewJournal.from("#{ViewJournal.table_name} FORCE INDEX(index_view_journals_on_shop_id_and_created_at)").where(
      #   created_at: dates
      # )
      _records = ReportShopActivity.where(
        report_date: dates
      )
      if records.where_sql.present?
        _records = _records.where(shop_id: records.select(:shop_id))
      end

      _records.group(:shop_id).order(
        "sum(`viewer_count`) desc"
        ).limit(limit).pluck_s(
          Arel.sql("`shop_id` as shop_id"),
          Arel.sql("sum(`viewer_count`) as count")
        )
    end

    def share_count_rank(records: , dates: , limit: 10, min_daily_value: 50)
      _records = ReportShopActivity.where(
        report_date: dates
      )
      if records.where_sql.present?
        _records = _records.where(shop_id: records.select(:shop_id))
      end

      _records.group(:shop_id).order(
        "sum(`shared_count`) desc"
        ).limit(limit).pluck_s(
          Arel.sql("`shop_id` as shop_id"),
          Arel.sql("sum(`shared_count`) as count")
        )
    end

    def city_rank(records: , dates: , limit: 10)
      records.where(
        created_at: dates
      ).where.not(city: "").
      group(:city).order("count(city) desc").
      limit(limit).pluck_s(
        Arel.sql("`city` as city"),
        Arel.sql("count(`city`) as count")
      )
    end

    def insert_to_report_activity_partial_shops(records: )
      _records = Array.wrap(records).uniq.compact

      ShopActivity::UpdateReport.insert_to_partial_shops(
        id: _records.map(&:shop_id)
      )
    end
  end
end