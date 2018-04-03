class RenameIdCardToIdcardOnShopUserCard < ActiveRecord::Migration[5.2]
  def change
    rename_column :shop_users, :id_card, :idcard
  end
end