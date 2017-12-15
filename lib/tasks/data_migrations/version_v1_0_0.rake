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
  end
end