class Order < ApplicationRecord
  belongs_to :shop, primary_key: :id,
    foreign_key: :shop_id,
    class_name: :Shop, required: false

  has_one :shopkeeper, through: :shop

  has_many :order_subs, foreign_key: :order_no, primary_key: :order_no
  has_many :order_expresses, through: :order_subs

  has_many :order_details, through: :order_subs
  has_many :products, through: :order_subs

  enum order_status: {
    awaiting_payment: 0,
    awaiting_delivery: 1,
    deliveried: 2,
    finished: 3,
    canceled: 4,
    finished_trouble: 5
  }
  enum order_type: {
    create_shop: 0,
    shopkeeper_order: 1,
    third_order: 2
  }
  enum ref_type: {
    wechat_friend: 0,
    app: 1,
    wechat_moment: 2,
    qq: 3,
    qq_zone: 4,
    sms: 5,
    qrcord: 6
  }
  enum comm_setted: {
    yes: 1,
    no: 0
  }, _prefix: true
  enum payed_push: {
    yes: 1,
    no: 0
  }, _prefix: true
  enum global_freight_flag: {
    yes: 1,
    no: 0
  }, _prefix: true
  enum reduce_type: {
    activity: 0
  }

  scope :sales_order, ->{
    where(
      order_type: order_types.slice(:shopkeeper_order, :third_order).values
    )
  }
  scope :valided_order, ->{
    where.not(
      order_status: order_statuses.slice(:canceled, :finished_trouble).values
    )
  }
  scope :undelivered_than_hour, ->(hour: 48) {
    awaiting_delivery.where(deliver_time: nil).where("TIMESTAMPDIFF(hour, `orders`.`pay_time`, :datetime) >= :interval", datetime: Time.now.beginning_of_minute, interval: hour)
  }

  include Searchable

  simple_search_on fields: [
    :order_no,
    "shopkeepers.user_name"
  ], joins: :shopkeeper

  def to_s
    order_no
  end
end