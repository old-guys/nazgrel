class SesameMall::ShopActiveRecordSeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :id
  end

  def fetch_records(ids: )
    ::ShopActiveRecord.where(primary_key => ids)
  end

  def to_model(data, record: nil)
    record ||= ::ShopActiveRecord.new

    record.assign_attributes(
      id: data[:id],

      session_id: data[:session_id],
      user_id: data[:user_id],
      shop_id: data[:shop_id],
      user_name: data[:user_name],
      shop_type: data[:shop_type],
      phone: data[:phone],

      os_type: data[:os_type],
      os_version: data[:os_version],
      network_type: data[:network_type],

      device_id: data[:device_id],
      ip_address: data[:ip_address],
      mac_address: data[:mac_address],

      app_version: data[:app_version],
      user_agent: data[:user_agent],

      label: data[:label],
      deployment_key: data[:deployment_key],
      is_pending: data[:is_pending],
      package_size: data[:package_size],
      description: data[:description],

      first_install_time: parse_no_timezone(datetime: data[:first_install_time]),
      last_update_time: parse_no_timezone(datetime: data[:last_update_time]),

      created_at: parse_no_timezone(datetime: data[:create_time]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:update_time])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::ShopActiveRecord)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::ShopActiveRecord, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end
