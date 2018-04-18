class SesameMall::ProductSkuSeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :ID
  end

  def fetch_records(ids: )
    ::ProductSku.where(id: ids)
  end

  def to_model(data, record: nil)
    record ||= ::ProductSku.new

    record.assign_attributes(
      id: data[:ID],

      product_id: data[:PRODUCT_ID],
      price: data[:PRICE],

      sku_n: data[:SKU_N],
      sales_price: data[:SALES_PRICE],
      sock_n: data[:STOCK_N],

      sku_img: data[:SKU_IMG],
      cost_price: data[:COST_PRICE],
      status: ::ProductSku.statuses.invert[data[:STATUS].to_i],

      sales_n: data[:SALE_N],
      sku_info: data[:SKU_INFO],
      commission_rate: data[:COMMISSION_RATE],
      market_price: data[:MARKET_PRICE],
      is_online: ::ProductSku.is_onlines.invert[data[:ISSHANGJIA].to_i],

      version: data[:VERSION],
      limit_count: data[:limitCount],
      random_base_n: data[:RANDOM_BASE_N],

      stock_random_n: data[:STOCK_RANDOM_N],
      stock_n_ch: data[:STOCK_N_CH],

      product_date: data[:proDate],
      expire_date: data[:expireDate],

      # created_at: parse_no_timezone(datetime: data[:DATE]),
      # updated_at: record.updated_at || parse_no_timezone(datetime: data[:update_time])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::ProductSku)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::ProductSku, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end