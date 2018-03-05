class CreateActTickets < ActiveRecord::Migration[5.1]
  def change
    create_table :act_tickets, comment: "券" do |t|
      t.string :title, comment: "标题"
      t.decimal :amount, precision: 10, scale: 0, comment: "面额"
      t.decimal :condition, precision: 10, scale: 0, comment: "使用条件"
      t.integer :stock, comment: "库存"
      t.integer :count_per_user, comment: "每个用户可领数量"
      t.integer :sale_count, comment: "已领数量"
      t.bigint :usable_day_count, comment: "可用天数"
      t.integer :ticket_type, default: 1, comment: "1:普通券,2:开店抵扣券"
      t.string :image, comment: "券图片"
      t.string :image_back_color, comment: "券图片背景色"

      t.timestamps
    end
  end
end