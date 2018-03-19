class ChangeUserIdOnOrder < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :user_id, :string
  end
end
