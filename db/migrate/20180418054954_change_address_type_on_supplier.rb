class ChangeAddressTypeOnSupplier < ActiveRecord::Migration[5.2]
  def change
    change_column :suppliers, :address, :string, comment: "地址"
  end
end