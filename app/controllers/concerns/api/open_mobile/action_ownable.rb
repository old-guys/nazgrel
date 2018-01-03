module Api::OpenMobile::ActionOwnable
  extend ActiveSupport::Concern

  included do
  end

  private
  def set_shops
    @permit_shops = if params[:shop_id].present?
      _record = Shop.find_by(id: params[:shop_id])

      _record.present? ? _record.descendant_entities : Shop.none
    else
      Shop.all
    end
  end
  def set_shopkeepers
    @permit_shopkeepers = if params[:shop_id].present?
      _record = Shopkeeper.find_by(shop_id: params[:shop_id])

      _record.present? ? _record.descendant_entities : Shopkeeper.none
    else
      Shopkeeper.all
    end
  end
end