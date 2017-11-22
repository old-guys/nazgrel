class AddStatusToChannel < ActiveRecord::Migration[5.1]
  def change
    add_column :channels, :status, :integer, default: 0, null: false, comment: "状态: 0: 正常, 1: 锁定"
    add_index :channels, :status
  end
end
