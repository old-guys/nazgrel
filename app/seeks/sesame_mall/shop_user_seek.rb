class SesameMall::ShopUserSeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :id
  end

  def fetch_records(ids: )
    ::ShopUser.where(primary_key => ids)
  end

  def to_model(data, record: nil)
    record ||= ::ShopUser.new

    record.assign_attributes(
      id: data[:id],

      user_id: data[:user_id],
      idcard: data[:idcard],
      phone: data[:user_phone],
      nickname: data[:nick_name],
      real_name: data[:real_name],
      user_photo: data[:user_photo],

      age: data[:age],
      sex: ::ShopUser.sexes.invert[data[:sex]],
      birthday: data[:birthday],

      city: data[:city],
      province: data[:province],
      area: data[:area],

      verify_flag: ::ShopUser.verify_flags.invert[data[:verify_flag]],
      status: ::ShopUser.statuses.invert[data[:status]],
      source: ::ShopUser.sources.invert[data[:source]],
      shopkeeper_flag: ::ShopUser.shopkeeper_flags.invert[data[:shopkeeper_flag]],

      wechat_openid: data[:wechat_openid],
      wechat_flag: ::ShopUser.wechat_flags.invert[data[:wechat_flag]],

      created_at: parse_no_timezone(datetime: data[:create_time]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:update_time])
    )

    if record.age.blank?
      record.set_idcard_belong_to
    end

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::ShopUser)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::ShopUser, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end