class CreateChannels < ActiveRecord::Migration[5.1]
  def change
    create_table :channels, comment: "渠道" do |t|
      t.string :name, null: false, default: "", comment: "渠道名称"
      t.integer :type, null: false, default: 0, comment: "渠道类型"
      t.integer :source, null: false, default: 0, comment: "渠道来源"

      t.timestamps
    end
  end
end
