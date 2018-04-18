class ChangePhoneTypeOnSupplier < ActiveRecord::Migration[5.2]
  def change
    change_column :suppliers, :phone, :string, comment: "手机"
  end
end