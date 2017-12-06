class SesameMall::OrderDetailSeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :id
    self.source_primary_key = :id
  end

  def fetch_records(ids: )
    ::OrderDetail.where(primary_key => ids)
  end

  def to_model(data, record: nil)
    record ||= ::OrderDetail.new

    record.assign_attributes(
      id: data[:id],

      order_no: data[:order_no],
      sub_order_no: data[:sub_order_no],

      product_sku_id: data[:prod_sku_id],
      product_id: data[:prod_id],
      product_skuinfo: data[:prod_skuinfo],

      product_name: data[:prod_name],
      product_image: data[:prod_image],
      product_num: data[:prod_num],
      product_market_price: data[:prod_market_price],
      product_sale_price: data[:prod_sale_price],

      commission_rate: data[:commission_rate],
      is_free_delivery: ::OrderDetail.is_free_deliveries.invert[data[:is_free_delivery]],
      express_price: data[:express_price],

      supplier_id: data[:supplier_id],
      activity_id: data[:activity_id],

      product_label_type: ::OrderDetail.product_label_types.invert[data[:prod_label_type].to_i],
      product_group_id: data[:prod_group_id],
      product_old_sale_price: data[:prod_old_sale_price],

      created_at: parse_no_timezone(datetime: data[:create_time]),
      updated_at: parse_no_timezone(datetime: data[:update_time])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::OrderDetail)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::OrderDetail, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end
