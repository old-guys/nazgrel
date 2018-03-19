class ChangeLoginFieldToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :phone, :string
    add_index :users, :phone

    remove_index :users, :email
    add_index :users, :email
  end
end
