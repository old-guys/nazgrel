class CreateTriggerConfigs < ActiveRecord::Migration[5.1]
  def change
    create_table :trigger_configs, comment: "数据库触发器配置" do |t|
      t.string :model_type, comment: "模块名"
      t.integer :source, comment: "数据来源"

      t.timestamps
    end
  end
end
