class SesameMall::UserAddressSeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :id
  end

  def fetch_records(ids: )
    ::UserAddress.where(primary_key => ids)
  end

  def to_model(data, record: nil)
    record ||= ::UserAddress.new

    record.assign_attributes(
      id: data[:id],

      ref: ::UserAddress.refs.invert[data[:ref]],
      user_id: data[:user_id],

      province: data[:province],
      city: data[:city],
      district: data[:district],
      detail_address: data[:detail_address],

      recv_phone_no: data[:recv_phone_no],
      recv_user_name: data[:recv_user_name],

      is_default: ::UserAddress.is_defaults.invert[data[:is_default]],
      is_deleted: ::UserAddress.is_deleteds.invert[data[:is_deleted]],


      created_at: parse_no_timezone(datetime: data[:create_time]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:modify_time])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::UserAddress)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::UserAddress, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end