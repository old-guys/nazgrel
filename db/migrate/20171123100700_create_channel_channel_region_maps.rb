class CreateChannelChannelRegionMaps < ActiveRecord::Migration[5.2]
  def change
    create_table :channel_channel_region_maps, comment: "渠道渠道大区中间表" do |t|
      t.references :channel, foreign_key: true, index: true, comment: "渠道ID"
      t.references :channel_region, foreign_key: true, index: true, comment: "渠道大区ID"

      t.timestamps
    end
  end
end
