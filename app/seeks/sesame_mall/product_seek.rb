class SesameMall::ProductSeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :ID
  end

  def fetch_records(ids: )
    ::Product.where(primary_key => ids)
  end

  def to_model(data, record: nil)
    record ||= ::Product.new

    record.assign_attributes(
      id: data[:ID],

      category_id: data[:CATEGGORY_ID],
      opt_user: data[:OPT_USER],

      no: data[:PRODUCT_NO],
      name: data[:PRODUCT_NAME],
      desc: data[:PRODUCT_DESC],
      status: Product.statuses.invert[data[:STATUS].to_i],

      price: data[:PRICE],
      max_price: data[:MAX_PRICE],
      min_price: data[:MIN_PRICE],

      sale_number: data[:SALE_N],
      total_number: data[:TOTALNUM],
      distribution_number: data[:DISTRIBUTION_NUM],
      express_price: data[:EXPRESS_PRICE],

      is_pinkage: Product.is_pinkages.invert[data[:IS_PINKAGE].to_i],
      default_img: data[:DEFAULT_IMG],
      commission_rate: data[:COMMISSION_RATE],

      sort_id: data[:SORT_ID],
      label_type: Product.label_types.invert[data[:LABEL_TYPE].to_i],
      top_sort: data[:TOP_SORT],
      sper_product_no: data[:SPER_PRODUCT_NO],

      created_at: parse_no_timezone(datetime: data[:CREATE_DATE]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:UPDATE_DATE])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::Product)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::Product, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end