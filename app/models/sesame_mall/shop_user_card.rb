class ShopUserCard < ApplicationRecord
  alias_attribute :idcard, :id_card

  belongs_to :shop_user, primary_key: :user_id,
    foreign_key: :user_id,
    class_name: :ShopUser, required: false

  belongs_to :shopkeeper, primary_key: :user_id,
    foreign_key: :user_id,
    class_name: :Shopkeeper, required: false
end