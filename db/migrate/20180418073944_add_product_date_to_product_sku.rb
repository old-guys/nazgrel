class AddProductDateToProductSku < ActiveRecord::Migration[5.2]
  def change
    add_column :product_skus, :product_date, :date, after: :stock_n_ch, comment: "生产日期"
    add_column :product_skus, :expire_date, :date, after: :product_date, comment: "有效期"
  end
end