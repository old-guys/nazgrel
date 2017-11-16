class CreateChannelApiKeys < ActiveRecord::Migration[5.1]
  def change
    create_table :channel_api_keys, comment: "渠道用户api key" do |t|
      t.references :channel_user, foreign_key: true, comment: "渠道用户"
      t.string :access_token, comment: "access token"

      t.timestamps
    end
    add_index :channel_api_keys, :access_token
  end
end
