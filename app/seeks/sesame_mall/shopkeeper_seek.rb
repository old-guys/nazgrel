class SesameMall::ShopkeeperSeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :id
  end

  def fetch_records(ids: )
    ::Shopkeeper.where(primary_key => ids)
  end

  def to_model(data, record: nil)
    record ||= ::Shopkeeper.new

    record.assign_attributes(
      id: data[:id],

      user_id: data[:user_id],
      user_name: data[:user_name],
      user_phone: data[:user_phone],
      user_photo: data[:user_photo],
      user_grade: ::Shopkeeper.user_grades.invert[data[:user_grade]],

      shop_id: data[:shop_id],

      total_income_amount: data[:total_income_amount],
      balance_amount: data[:balance_amount],
      withdraw_amount: data[:withdraw_amount],
      blocked_amount: data[:blocked_amount],
      invite_amount: data[:invite_amount],
      invite_number: data[:invite_number],
      order_amount: data[:order_amount],
      order_number: data[:order_number],

      status: data[:status],
      invite_user_id: data[:invite_user_id],
      city: data[:city],
      province: data[:province],
      ticket_no: data[:ticket_no],

      expire_time: parse_no_timezone(datetime: data[:expire_time]),
      use_invite_number: data[:use_invite_number],
      org_grade: data[:org_grade],

      created_at: parse_no_timezone(datetime: data[:create_time]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:update_time])
    )

    record.assign_attributes(
      path: data[:parent_ids].to_s.split(",").reject{|s| s.to_i <= 0}.push(0).reverse.push(record.user_id).join("/")
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::Shopkeeper)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::Shopkeeper, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end