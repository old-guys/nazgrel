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
  end
end
