class AddChannelRegionRefToChannelUser < ActiveRecord::Migration[5.1]
  def change
    add_reference :channel_users, :channel_region, foreign_key: true, comment: "渠道大区ID"
  end
end
