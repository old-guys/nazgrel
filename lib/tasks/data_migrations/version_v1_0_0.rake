namespace :data_migrations do
  namespace :version do
    desc 'migrate shop from channel to channel_user'
    task :v1_0_3_channel_user_shop => :environment do
      ChannelUser.joins(:channel).update_all(%Q{
        `channel_users`.`shopkeeper_user_id` = `channels`.`shopkeeper_user_id`,
        `channel_users`.`shop_id` = `channels`.`shop_id`
      })
    end

    desc 'init seek trigger for sesame_mall'
    task :v1_0_5_init_seek_trigger => :environment do
      SesameMall::ProductSeek.whole_sync
      SesameMall::ProductShopSeek.whole_sync
      SesameMall::OrderDetailSeek.whole_sync

      TriggerService.setup source: :sesame_mall

      _klasses = [
        SesameMall::Source::IncomeRecord, SesameMall::Source::Order,
        SesameMall::Source::OrderDetail,
        SesameMall::Source::ProductShop, SesameMall::Source::Product,
        SesameMall::Source::Shop, SesameMall::Source::Shopkeeper
      ]

      _klasses.each {|klass|
        TriggerService.setup_trigger klass: klass
      }
    end

    desc 'init seek trigger for sesame_mall sub order'
    task :v1_0_6_init_seek_trigger => :environment do
      SesameMall::OrderSubSeek.whole_sync
      SesameMall::OrderExpressSeek.whole_sync

      _klasses = [
        SesameMall::Source::OrderSub, SesameMall::Source::OrderExpress
      ]

      _klasses.each {|klass|
        TriggerService.setup_trigger klass: klass
      }
    end

    desc 'migrate shopkeeper#commission_income_amount'
    task :v1_0_7_shopkeeper_income_amount => :environment do
      Shopkeeper.where(commission_income_amount: nil).find_each {|s|
        _commission_income_amount = s.orders.sales_order.valided_order.sum(:comm)

        s.update_columns(commission_income_amount: _commission_income_amount)
      }
    end

    desc 'init seek trigger for sesame_mall sub order'
    task :v1_0_8_init_seek_trigger => :environment do
      SesameMall::ShopUserSeek.whole_sync
      SesameMall::ShopWechatUserSeek.whole_sync
      SesameMall::SupplierSeek.whole_sync

      _klasses = [
        SesameMall::Source::ShopUser, SesameMall::Source::ShopWechatUser,
        SesameMall::Source::Supplier
      ]

      _klasses.each {|klass|
        TriggerService.setup_trigger klass: klass
      }
    end

    desc 'init report_channel_shop_newer'
    task :v1_0_10_init_report_channel_shop_newer => :environment do
      Channel.normal.in_batches(of: 50) do |records|
        ChannelShopNewer::Reporting.reset_report(channels: records)
      end
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

    desc 'migrate shop#channel_id'
    task :v1_0_12_migrate_shop_channel_id => :environment do
      Shop.preload(:shopkeeper).in_batches {|records|
        Shopkeeper.with_preload_parents(records: records.map(&:shopkeeper).compact)

        records.each {|record|
          if record.shopkeeper
            record.set_channel_path
            record.save
          end
        }
      }
    end

    desc 'migrate shop info'
    task :v1_0_13_migrate_shop_info => :environment do
      SesameMall::Source::Shop.in_batches {|records|
        _shops = Shop.where(id: records.pluck(:ID))

        Shop.transaction do
          _shops.each {|record|
            _source = records.find{|source| source.ID == record.id}
            if _source and record.shop_img.blank?
              record.update_columns(
                shop_template_id: _source.SHOP_TEMPLATE_ID,
                shop_theme: _source.SHOP_THEME,
                shop_img: _source.SHOP_IMG,
                share_shop_qrcode: _source.SHARE_SHOP_QRCODE
              )
            end
          }
        end
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

    desc 'migrate shopkeeper info'
    task :v1_1_2_migrate_shopkeeper_info => :environment do
      SesameMall::InvitePayRecordSeek.whole_sync

      _klasses = [
        SesameMall::Source::InvitePayRecord
      ]

      _klasses.each {|klass|
        TriggerService.setup_trigger klass: klass
      }

      SesameMall::Source::Shopkeeper.in_batches {|records|
        _shopkeepers = Shopkeeper.where(id: records.pluck(:id))
        _keys = %w(
          invite_code invite_qrcode_path my_qrcode_path
          remark ticket_send_flag
        )

        Shopkeeper.transaction do
          _shopkeepers.each {|record|
            _source = records.find{|source| source.id == record.id}
            if _source and record.invite_code.blank?
              record.update_columns(
                _source.attributes.slice(*_keys)
              )
            end
          }
        end
      }
    end

    desc 'migrate shop_acitvity total_stat'
    task :v1_1_3_migrate_shop_acitvity_total_stat => :environment do
      shops = Shop.all
      ShopActivity::UpdateReport.update_report(
        shops: shops.preload(:shopkeeper),
        force_update: true
      )

      CumulativeShopActivity::UpdateReport.update_report(
        shops: shops,
        interval_time: 8.hours,
        force_update: true
      )
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

    task :v1_1_3_3_migrate_shop_activity_children_stat_field => :environment do
      shops = Shop.where(id: ReportShopActivity.where(report_date: Date.today).select(:shop_id))
      ShopActivity::UpdateReport.update_report(
        shops: shops.preload(:shopkeeper),
        force_update: true
      )

      CumulativeShopActivity::UpdateReport.update_report(
        shops: shops,
        interval_time: 8.hours,
        force_update: true
      )
    end
  end
end