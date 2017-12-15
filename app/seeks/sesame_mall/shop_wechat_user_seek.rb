class SesameMall::ShopWechatUserSeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :id
  end

  def fetch_records(ids: )
    ::ShopWechatUser.where(primary_key => ids)
  end

  def to_model(data, record: nil)
    record ||= ::ShopWechatUser.new

    record.assign_attributes(
      id: data[:id],

      user_id: data[:user_id],
      openid: data[:openid],
      headimgurl: data[:headimgurl],
      nickname: data[:nickname],

      city: data[:city],
      province: data[:province],
      country: data[:country],

      gender: ::ShopWechatUser.genders.invert[data[:gender]],

      unionid: data[:unionid],
      appid: data[:appid],
      mobile: data[:mobile],

      status: ::ShopWechatUser.statuses.invert[data[:status]],

      created_at: parse_no_timezone(datetime: data[:created_time]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:update_time])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::ShopWechatUser)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::ShopWechatUser, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end