class AddInviteCodeDescToShopkeeper < ActiveRecord::Migration[5.2]
  def change
    add_column :shopkeepers, :invite_code, :string, after: :status, comment: "邀请码"
    add_column :shopkeepers, :invite_qrcode_path, :string, after: :invite_code, comment: "邀请二维码图片路径"
    add_column :shopkeepers, :my_qrcode_path, :string, after: :invite_qrcode_path, comment: "我的二维码图片路径(下级导师)"
    add_column :shopkeepers, :remark, :string, after: :ticket_no, comment: "备注"
    add_column :shopkeepers, :ticket_send_flag, :integer, after: :remark, comment: "开店优惠券是否发送0：否，1：是"

    add_column :shopkeepers, :create_shop_amount, :decimal, precision: 11, scale: 3, default: 0, comment: "开店支付金额"
  end
end