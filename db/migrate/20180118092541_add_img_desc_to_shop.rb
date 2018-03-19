class AddImgDescToShop < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :shop_template_id, :bigint, comment: "店铺模板编号"
    add_column :shops, :shop_theme, :string, comment: "主题图片"
    add_column :shops, :shop_img, :string, comment: "店铺头像"
    add_column :shops, :share_shop_qrcode, :string, comment: "店铺分享二维码"
  end
end