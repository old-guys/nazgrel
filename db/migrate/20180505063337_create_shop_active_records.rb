class CreateShopActiveRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :shop_active_records, comment: "活跃店主记录" do |t|
      t.string :session_id, comment: "session ID"
      t.bigint :user_id, comment: "用户ID"
      t.bigint :shop_id, comment: "店铺ID"
      t.string :user_name, comment: "用户名称"
      t.integer :shop_type, comment: "店铺等级（0:白金，1：黄金，2：见习）"
      t.string :phone, comment: "手机号码"

      t.string :os_type, comment: "操作系统类型"
      t.string :os_version, comment: "操作系统版本"
      t.string :network_type, comment: "操作系统版本"
      t.string :device_id, comment: "设备ID"
      t.datetime :first_install_time, comment: "第一次安装时间"
      t.datetime :last_update_time, comment: "最后一次更新时间"
      t.string :ip_address, comment: "IP地址"
      t.string :mac_address, comment: "mac地址"
      t.string :app_version, comment: "app版本"
      t.string :user_agent, comment: "设备访问代理信息"
      t.string :label, comment: "热更新版本"
      t.string :deployment_key, comment: "部置Key"
      t.string :is_pending, comment: "是否更新完成，等待下次重启(0:已更新;1:未更新)"
      t.float :package_size, comment: "热更新包大小"
      t.string :description, comment: "热更新描述信息"

      t.timestamps
    end
  end
end
