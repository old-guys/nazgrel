class SesameMall::OrderSubSeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :sub_order_no
    self.source_primary_key = :sub_order_no
  end

  def fetch_records(ids: )
    ::OrderSub.where(primary_key => ids)
  end

  def to_model(data, record: nil)
    record ||= ::OrderSub.new

    record.assign_attributes(
      sub_order_no: data[:sub_order_no],
      order_no: data[:order_no],

      order_express_id: data[:express_id],

      pay_time: parse_no_timezone(datetime: data[:pay_time]),
      deliver_time: parse_no_timezone(datetime: data[:deliver_time]),
      finish_time: parse_no_timezone(datetime: data[:finish_time]),
      cancel_time: parse_no_timezone(datetime: data[:cancel_time]),

      order_status: ::OrderSub.order_statuses.invert[data[:order_status].to_i],

      express_price: data[:express_price],
      sale_price: data[:sale_price],
      comm: data[:comm],
      pay_price: data[:pay_price],
      total_price: data[:total_price],

      shop_user_deliveried_push: ::OrderSub.shop_user_deliveried_pushes.invert[data[:shop_user_deliveried_push].to_i],
      user_deliveried_push: ::OrderSub.user_deliveried_pushes.invert[data[:user_deliveried_push].to_i],
      supplier_deliveried_push: ::OrderSub.supplier_deliveried_pushes.invert[data[:supplier_deliveried_push].to_i],

      remarks: data[:remarks],
      express_free_price: data[:express_free_price],
      version: data[:version],
      is_zone_freight: ::OrderSub.is_zone_freights.invert[data[:is_zone_freight].to_i],

      sync_price: ::OrderSub.sync_prices.invert[data[:sync_price].to_i],
      refund_time: parse_no_timezone(datetime: data[:refund_time]),
      refund_apply_time: parse_no_timezone(datetime: data[:refund_apply_time]),

      refunded_amount: data[:refunded_amount],
      refunding_amount: data[:refunding_amount],
      refunded_product_num: data[:refunded_product_num],
      refunding_product_num: data[:refunding_product_num],
      refunded_comm: data[:refunded_comm],
      refunding_comm: data[:refunding_comm],

      order_sub_status: ::OrderSub.order_sub_statuses.invert[data[:order_sub_status].to_i],
      old_order_status: data[:old_order_status],
      delivered_flag:  ::OrderSub.delivered_flags.invert[data[:delivered_flag].to_i],
      sub_product_num: data[:sub_product_num],

      supplier_id: data[:supplier_id],
      activity_id: data[:activity_id],

      created_at: parse_no_timezone(datetime: data[:create_time]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:update_time])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::OrderSub)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::OrderSub, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end