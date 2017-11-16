class Shop < ApplicationRecord
  has_one :shopkeeper

  def ancestor_shopkeepers
    @_shopes ||= Shopkeeper.where(user_id: shopkeeper.path.to_s.split("/"))
  end

  def set_path
    _user_ids = shopkeeper.path.to_s.split("/")

    self.path = _user_ids.map{|s|
      if s != "0"
        ancestor_shopkeepers.find{|record| record.user_id.to_s == s}.try(:shop_id)
      else
        "0"
      end
    }.compact.join("/")
  end

  def set_channel_path
    _user_ids = shopkeeper.path.to_s.split("/")
    _channels = Channel.where(shopkeeper_user_id: _user_ids).pluck_s(:id, :shopkeeper_user_id)
    _shop_ids = []

    _user_ids.reverse.each{|user_id|
      _shop_id = ancestor_shopkeepers.find{|record| record.user_id.to_s == user_id}.try(:shop_id)
      _shop_ids << _shop_id if _shop_id.to_i > 0

      if _channels.find{|s| s.shopkeeper_user_id.to_s == user_id}
        break
      end
    }
    _shop_ids.push("0")

    self.channel_path = _shop_ids.reverse.join("/")
  end
end
