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
      # REVIEW 不同步因为, shopkeeper#order_amount 计算逻辑不一致
      # order_amount: data[:order_amount],
      # REVIEW 不同步因为, shopkeeper#order_number 计算逻辑不一致
      # order_number: data[:order_number],

      invite_user_id: data[:invite_user_id],
      # city: data[:city],
      # province: data[:province],
      ticket_no: data[:ticket_no],

      invite_code: data[:invite_code],
      invite_qrcode_path: data[:invite_qrcode_path],
      my_qrcode_path: data[:my_qrcode_path],
      remark: data[:remark],

      ticket_send_flag: ::Shopkeeper.ticket_send_flags.invert[data[:ticket_send_flag]],
      status: ::Shopkeeper.statuses.invert[data[:status]],

      expire_time: parse_no_timezone(datetime: data[:expire_time]),
      use_invite_number: data[:use_invite_number],
      org_grade: data[:org_grade],

      created_at: parse_no_timezone(datetime: data[:create_time]),
      updated_at: record.updated_at || parse_no_timezone(datetime: data[:update_time])
    )

    _path = data[:parent_ids].to_s.split(",").reject{|s|
      s.to_i <= 0
    }.push(0).reverse.push(record.user_id).join("/")

    record.assign_attributes(
      path: _path,
    )

    # REVIEW shopkeeper#order_number
    set_shopkeeper_order_content(record: record) if record.persisted?

    if record.persisted?
      _commission_income_amount = record.income_records.commission_income.confirmed.
        sum(:income_amount)
      # _invite_amount = record.income_records.invite_income.confirmed.
      #   sum(:income_amount)
      _team_income_amount = record.income_records.team_income.confirmed.
        sum(:income_amount)
      _shop_sales_amount = record.orders.sales_order.valided_order.
        where(
          order_no: record.commission_income.confirmed.select(:order_id)
        ).
        sum(:pay_price).to_f

      record.assign_attributes(
        commission_income_amount: _commission_income_amount,
        # invite_amount: _invite_amount,
        team_income_amount: _team_income_amount,
        shop_sales_amount: _shop_sales_amount,
      )
    end

    record
  end

  private
  def set_shopkeeper_order_content(record: )
    return if not record.try(:persisted?)
    _order_number = record.orders.valided_order.sales_order.size
    return if record.order_number == _order_number

    _order_amount = record.orders.sales_order.valided_order.sum(:total_price)
    _shopkeeper_order_number = record.orders.valided_order.sales_order.where(
      user_id: record.user_id
    ).size
    _shopkeeper_order_amount = record.orders.valided_order.sales_order.where(
      user_id: record.user_id
    ).sum(:total_price)

    record.assign_attributes(
      order_number: _order_number,
      order_amount: _order_amount,
      shopkeeper_order_number: _shopkeeper_order_number,
      shopkeeper_order_amount: _shopkeeper_order_amount,
      sale_order_number: _order_number - _shopkeeper_order_number,
      sale_order_amount: _order_amount - _shopkeeper_order_amount,
    )
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