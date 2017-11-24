class AddCityToChannel < ActiveRecord::Migration[5.1]
  def change
    add_column :channels, :city, :string, comment: "城市"
  end
end
