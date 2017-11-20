class SesameMall::OrderSeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :order_no
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

      order_type: data[:order_type],
      ref_type: data[:ref_type],

      pay_time: data[:pay_time],
      deliver_time: data[:deliver_time],
      finish_time: data[:finish_time],
      cancel_time: data[:cancel_time],

      order_status: data[:order_status].to_i,

      express_price: data[:express_price],
      sale_price: data[:sale_price],
      comm: data[:comm],
      pay_price: data[:pay_price],
      total_price: data[:total_price],
      comm_setted: data[:comm_setted],

      openid: data[:openid],
      payed_push: data[:payed_push],
      remarks: data[:remarks],

      activity_id: data[:activity_id],

      global_freight: data[:global_freight],
      global_freight_flag: data[:global_freight_flag],

      user_ticket_id: data[:user_ticket_id],
      reduce_price: data[:reduce_price],
      discount_rate: data[:discount_rate],
      reduce_type: data[:reduce_type],

      created_at: data[:creat_time],
    )

    record
  end

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::Order, key: :shop_id)
    end

    def partial_sync(duration: 3.days)
      seek = self.new

      _time = Time.now
      _relation = SesameMall::Source::Order.where(
        create_time: duration.ago(_time).._time
      )
      seek.do_partial_sync(relation: _relation)
    end
  end
end
