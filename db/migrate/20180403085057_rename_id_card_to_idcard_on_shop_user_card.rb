class RenameIdCardToIdcardOnShopUserCard < ActiveRecord::Migration[5.2]
  def change
    rename_column :shop_user_cards, :id_card, :idcard
  end
end