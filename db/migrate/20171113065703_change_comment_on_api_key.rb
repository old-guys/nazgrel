class ChangeCommentOnApiKey < ActiveRecord::Migration[5.2]
  def change
    set_table_comment :api_keys, "用户api key"
    set_column_comment :api_keys, :user_id, "用户id"
    set_column_comment :api_keys, :access_token, "access token"

    set_column_comment :api_keys, :created_at, "创建时间"
    set_column_comment :api_keys, :updated_at, "更新时间"
  end
end
