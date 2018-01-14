module Api::OpenMobile::ActionOwnable
  extend ActiveSupport::Concern

  included do
  end

  private
  def set_shops
    @permit_shops = if params[:shop_id].present?
      @permit_shop = Shop.find_by(id: params[:shop_id])

      @permit_shop.present? ? @permit_shop.descendant_entities : Shop.none
    else
      Shop.all
    end
  end
  def set_shopkeepers
    @permit_shopkeepers = if params[:shop_id].present?
      @permit_shop = Shop.find_by(id: params[:shop_id])

      @permit_shop.present? ? @permit_shop.shopkeeper.descendant_entities : Shopkeeper.none
    else
      Shopkeeper.all
    end
  end
end