class SesameMall::BankCardSeek
  include SesameMall::Seekable

  def initialize(opts = {})
  end

  def fetch_records(ids: )
    ::BankCard.where(id: ids)
  end

  def to_model(data, record: nil)
    record ||= ::BankCard.new

    record.assign_attributes(
      id: data[:id],

      user_id: data[:user_id],
      bank_id: data[:bank_id],
      bank_name: data[:bank_name],
      card_num: data[:card_num],
      mobile: data[:mobile],
      owner_name: data[:owner_name],
      card_type: ::BankCard.card_types.invert[data[:type]],

      card_address: data[:card_address],
      delete_status: ::BankCard.delete_statuses.invert[data[:delete_status]],
      status: ::BankCard.statuses.invert[data[:status]],

      province: data[:province],
      city: data[:city],

      err_type: data[:err_type],
      err_tip: data[:err_tip],

      created_at: parse_no_timezone(datetime: data[:create_time]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:update_time])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::BankCard)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::BankCard, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end