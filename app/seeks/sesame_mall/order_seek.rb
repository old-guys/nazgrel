class SesameMall::OrderSeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :order_no
    self.source_primary_key = :order_no
  end

  def fetch_records(ids: )
    ::Order.where(primary_key => ids)
  end

  def to_model(data, record: nil)
    record ||= ::Order.new

    record.assign_attributes(
      order_no: data[:order_no],

      user_id: data[:user_id],
      user_phone_no: data[:user_phone_no],
      user_name: data[:user_name],

      recv_user_name: data[:recv_user_name],
      recv_phone_no: data[:recv_phone_no],

      shop_id: data[:shop_id],
      shop_name: data[:shop_name],
      shop_username: data[:shop_username],
      shop_user_id: data[:shop_userid],
      shop_phone: data[:shop_phone],

      province: data[:province],
      city: data[:city],
      district: data[:district],
      detail_address: data[:detail_address],

      order_type: Order.order_types.invert[data[:order_type]],
      ref_type: Order.ref_types.invert[data[:ref_type]],

      pay_time: parse_no_timezone(datetime: data[:pay_time]),
      deliver_time: parse_no_timezone(datetime: data[:deliver_time]),
      finish_time: parse_no_timezone(datetime: data[:finish_time]),
      cancel_time: parse_no_timezone(datetime: data[:cancel_time]),

      order_status: ::Order.order_statuses.invert[data[:order_status].to_i],

      express_price: data[:express_price],
      sale_price: data[:sale_price],
      comm: data[:comm],
      pay_price: data[:pay_price],
      total_price: data[:total_price],
      comm_setted: ::Order.comm_setteds.invert[data[:comm_setted]],

      openid: data[:openid],
      payed_push: ::Order.payed_pushes.invert[data[:payed_push]],
      remarks: data[:remarks],

      activity_id: data[:activity_id],

      global_freight: data[:global_freight],
      global_freight_flag: ::Order.global_freight_flags.invert[data[:global_freight_flag]],

      user_ticket_id: data[:user_ticket_id],
      reduce_price: data[:reduce_price],
      discount_rate: data[:discount_rate],
      reduce_type: ::Order.reduce_types.invert[data[:reduce_type]],

      created_at: parse_no_timezone(datetime: data[:create_time]),
      updated_at: parse_no_timezone(datetime: data[:update_time])
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::Order)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::Order, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
end
