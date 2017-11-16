class CreateApiKeys < ActiveRecord::Migration[5.1]
  def change
    create_table :api_keys do |t|
      t.references :user, foreign_key: true, index: true
      t.string :access_token

      t.timestamps
    end
    add_index :api_keys, :access_token
  end
end
