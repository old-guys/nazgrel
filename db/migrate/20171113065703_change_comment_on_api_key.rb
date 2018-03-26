class ChangeCommentOnApiKey < ActiveRecord::Migration[5.2]
  def change
    change_table_comment :api_keys, "用户api key"

    change_column :api_keys, :user_id, :bigint, comment: "用户id"
    change_column :api_keys, :access_token, :string, comment: "access token"

    change_column :api_keys, :created_at, :datetime, comment: "创建时间"
    change_column :api_keys, :updated_at, :datetime, comment: "更新时间"
  end
end