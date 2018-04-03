class ShopUser < ApplicationRecord
  include OpenQueryable

  has_one :user_card, primary_key: :user_id,
    foreign_key: :user_id,
    class_name: :ShopUserCard, required: false

  enum sex: {
    female: 0,
    male: 1
  }
  enum verify_flag: {
    un_verify: 0,
    approved: 1,
    applying: 2,
    rejected: 3
  }
  enum status: {
    normal: 0,
    locked: 1,
    was_invalid: 2
  }
  enum source: {
    ishanggang: 0,
    sesamemall: 1
  }
  enum shopkeeper_flag: {
    yes: 1,
    no: 0
  }, _prefix: true
  enum wechat_flag: {
    yes: 1,
    no: 0
  }, _prefix: true

  def set_idcard_belong_to
    if idcard.present?
      _hash = idcard_belong_to_juhe idcard: idcard
      return if _hash.blank?

      self.birthday ||= Date.strptime(
        _hash["birthday"], "%Y年%m月%d日"
      )
      self.age = (Time.now.to_s(:number).to_i - birthday.to_time.to_s(:number).to_i)/10e9.to_i
    end
  end
end