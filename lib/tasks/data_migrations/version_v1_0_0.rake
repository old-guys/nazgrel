namespace :data_migrations do
  namespace :version do
    desc 'migrate shop from channel to channel_user'
    task :v1_0_3_channel_user_shop => :environment do
      ChannelUser.joins(:channel).update_all(%Q{
        `channel_users`.`shopkeeper_user_id` = `channels`.`shopkeeper_user_id`,
        `channel_users`.`shop_id` = `channels`.`shop_id`
      })
    end

    desc 'init seek trigger for view_journal share_journal'
    task :v1_0_11_init_seek_trigger => :environment do
      SesameMall::ViewJournalSeek.whole_sync
      SesameMall::ShareJournalSeek.whole_sync

      _klasses = [
        SesameMall::Source::ViewJournal, SesameMall::Source::ShareJournal,
      ]

      _klasses.each {|klass|
        TriggerService.setup_trigger klass: klass
      }
    end

    desc 'init web permission'
    task :v1_1_1_init_web_permission => :environment do
      data = [
        {
          name: "权限配置",
          subject: "权限管理",
          uid: "/permissions",
        },
        {
          name: "角色配置",
          subject: "权限管理",
          uid: "/roles",
        },
        {
          name: "用户配置",
          subject: "用户管理",
          uid: "/users",
        }
      ]

      data.map{|d|
        _record = Permission.where(uid: d[:uid]).first_or_initialize

        _record.update(
          d
        )
      }
    end

    task :v1_1_3_2_migrate_shop_income_amount => :environment do
      SesameMall::IncomeRecordSeek.whole_sync

      Shopkeeper.find_each {|record|
        _commission_income_amount = record.income_records.commission_income.confirmed.
          sum(:income_amount)
        # _invite_amount = record.income_records.invite_income.confirmed.
        #   sum(:income_amount)
        _team_income_amount = record.income_records.team_income.confirmed.
          sum(:income_amount)
        _shop_sales_amount = record.orders.sales_order.valided_order.
          where(
            order_no: record.income_records.commission_income.confirmed.select(:order_id)
          ).
          sum(:pay_price).to_f

        record.update(
          commission_income_amount: _commission_income_amount,
          # invite_amount: _invite_amount,
          team_income_amount: _team_income_amount,
          shop_sales_amount: _shop_sales_amount,
        )
      }
    end

    desc 'migrate daily_operational_report'
    task :v1_1_3_4_migrate_daily_operational_report => :environment do
      1.months.ago.to_date.upto(Date.today) {|date|
        DailyOperational::UpdateReport.update_report(
          report_date: date,
          force_update: true
        )
      }
    end

    desc 'init seek trigger for sesame_mall product_sku act_ticket'
    task :v1_1_3_5_init_seek_trigger => :environment do
      SesameMall::ProductSkuSeek.whole_sync
      SesameMall::ActTicketSeek.whole_sync
      SesameMall::ActTicketActivitySeek.whole_sync
      SesameMall::ActUserTicketSeek.whole_sync

      _klasses = [
        SesameMall::Source::ProductSku,
        SesameMall::Source::ActTicket,
        SesameMall::Source::ActTicketActivity,
        SesameMall::Source::ActUserTicket
      ]

      _klasses.each {|klass|
        TriggerService.setup_trigger klass: klass
      }
    end

    desc 'migrate shopkeeper coin'
    task :v1_1_3_8_migrate_shopkeeper_coin => :environment do
      _time = Time.parse("2018-03-06")
      Shopkeeper.where(updated_at: _time..6.days.since(_time)).in_batches(of: 100) {|records|
        _source_records = SesameMall::Source::Shopkeeper.where(id: records.map(&:id))

        records.each {|record|
          _source_record = _source_records.find{|source_record|
            source_record.id == record.id
          }
          record.assign_attributes(
            total_income_coin: _source_record.total_income_coin,
            balance_coin: _source_record.balance_coin,
            use_coin: _source_record.use_coin
          ) if _source_record
        }

        Shopkeeper.transaction do
          records.select(&:changed?).map(&:save)
        end
      }
    end
    desc 'migrate shopkeeper coin'
    task :v1_1_3_9_migrate_order_coin => :environment do
      SesameMall::OrderSeek.partial_sync(duration: 8.days)
    end
    desc 'migrate shopkeeper coin'
    task :v1_1_3_9_migrate_income_record_coin => :environment do
      SesameMall::IncomeRecordSeek.partial_sync(duration: 8.days)
    end
  end
end