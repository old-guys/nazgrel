class AddAreaToChannelRegion < ActiveRecord::Migration[5.2]
  def change
    add_column :channel_regions, :area, :string, comment: "区域"
  end
end
