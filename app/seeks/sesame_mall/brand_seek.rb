class SesameMall::BrandSeek
  include SesameMall::Seekable

  def initialize(opts = {})
  end

  def fetch_records(ids: )
    ::Brand.where(id: ids)
  end

  def to_model(data, record: nil)
    record ||= ::Brand.new

    record.assign_attributes(
      id: data[:id],

      no: data[:brandNo],
      supplier_id: data[:supplierId],

      cn_name: data[:brandChname],
      en_name: data[:brandEnname],

      logo: data[:brandLogo],
      big_logo: data[:bigLogo],
      desc: data[:brandDesc],

      status: data[:status],

      creator_user_id: data[:createNameId],
      updater_user_id: data[:updateNameId],
      freeze_user_id: data[:frozenNameId],
      thaw_user_id: data[:thawNameId],

      frozen_at: parse_no_timezone(datetime: data[:frozenDate]),
      thaw_at: parse_no_timezone(datetime: data[:thawDate]),

      created_at: parse_no_timezone(datetime: data[:createDate]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:updateDate])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::Brand)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::Brand, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end