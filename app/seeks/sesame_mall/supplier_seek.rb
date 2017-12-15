class SesameMall::SupplierSeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :id
  end

  def fetch_records(ids: )
    ::Supplier.where(primary_key => ids)
  end

  def to_model(data, record: nil)
    record ||= ::Supplier.new

    record.assign_attributes(
      id: data[:id],

      industry_id: data[:industryId],
      sup_no: data[:supNo],
      name: data[:supName],
      contacts: data[:supContancts],
      province_id: data[:provinceId],
      city_id: data[:cityId],

      status: ::Supplier.statuses.invert[data[:statu]],

      phone: data[:supPhone],
      address: data[:supAddress],

      url: data[:supUrl],
      logo: data[:supLogo],
      desc: data[:supDesc],


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

      seek.do_whole_sync(relation: SesameMall::Source::Supplier)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::Supplier, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end