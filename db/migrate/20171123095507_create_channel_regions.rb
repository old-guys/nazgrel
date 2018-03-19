class CreateChannelRegions < ActiveRecord::Migration[5.2]
  def change
    create_table :channel_regions, comment: "渠道大区" do |t|
      t.string :name, comment: "名称"
      t.integer :status, default: 0, null: false, comment: "状态 0:正常, 1: 冻结"

      t.timestamps
    end
  end
end
