class SesameMall::ShopSeek
  include SesameMall::Seekable
  attr_accessor :shopkeeper_seek

  before_process :process_shopkeeper
  after_process :after_process_shopkeeper

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :ID

    self.shopkeeper_seek = SesameMall::ShopkeeperSeek.new
  end

  def fetch_records(ids: )
    ::Shop.preload(:shopkeeper).where(primary_key => ids)
  end

  def to_model(data, record: nil)
    record ||= ::Shop.new

    record.assign_attributes(
      id: data[:ID],

      name: data[:SHOP_NAME],
      user_id: data[:USER_ID],
      desc: data[:SHOP_DESC],

      created_at: parse_no_timezone(datetime: data[:CREATE_DATE]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:UPDATE_TIME])
    )

    if record.shopkeeper.present?
      record.set_path
      record.set_channel_path
    end

    record
  end

  private
  def process_shopkeeper
    _shopkeepers = SesameMall::Source::Shopkeeper.where(
      shop_id: source_data.pluck(source_primary_key)
    )

    shopkeeper_seek.do_partial_sync(relation: _shopkeepers)
  end

  def after_process_shopkeeper(records: )
    _channels = Channel.where(
      shop_id: records.map{|s|
        s.channel_path.to_s.split("/")[1]
      }.uniq.compact
    )
    _channel_ids = Rails.cache.fetch("channel_ids:#{Digest::SHA1.hexdigest(_channels.to_sql)}", expires_in: 30.minutes) {
      _channels.pluck(:id)
    }

    ChannelShopNewer::UpdateReport.insert_to_partial_channels(
      id: _channel_ids
    )
    ShopActivity::UpdateReport.insert_to_partial_shops(
      id: records.map(&:id)
    )
    ShopEcn::UpdateReport.insert_to_partial_shops(
      id: records.map(&:ancestor_entity_ids).flatten.uniq
    )

    CityShopActivity::UpdateReport.insert_to_partial_city(
      city: records.map{|record|
        record.shopkeeper.try(:city)
      }.uniq
    )

    ChannelShopActivity::UpdateReport.insert_to_partial_channel(
      id: _channel_ids
    )
  end
  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::Shop)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(
        klass: SesameMall::Source::Shop,
        duration: duration
      )
      _shop_from_shopkeeper_relation = SesameMall::Source::Shop.where(
        USER_ID: source_records_from_seek_record(
          klass: SesameMall::Source::Shopkeeper,
          duration: duration
        ).select(:user_id)
      )

      seek.do_partial_sync(relation: _relation.or(_shop_from_shopkeeper_relation))
    end
  end
end