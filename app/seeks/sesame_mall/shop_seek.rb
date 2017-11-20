class SesameMall::ShopSeek
  include SesameMall::Seekable

  def initialize(opts = {})
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
      updated_at: parse_no_timezone(datetime: data[:UPDATE_TIME])
    )

    if record.shopkeeper.present?
      record.set_path
      record.set_channel_path
    end

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::Shop)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      shopkeeper_seek = SesameMall::ShopkeeperSeek.new

      _time = Time.now
      _relation = SesameMall::Source::Shop.where(
        UPDATE_TIME: duration.ago(_time).._time
      )
      _shopkeepers = SesameMall::Source::Shopkeeper.where(shop_id: _relation.select(:id))

      shopkeeper_seek.do_partial_sync(relation: _shopkeepers)
      seek.do_partial_sync(relation: _relation)
    end
  end
end
