class Export::Dev::ShopkeeperService
  include Export::BaseService

  def write_tree_body
    shopkeeper = collection.first

    if params["tree_depth"].present?
      render_shopkeeeper_children_body(shopkeeper: shopkeeper, tree_depth: params["tree_depth"].to_i)
    else
      (shopkeeper.tree_depth + 1).upto(shopkeeper.tree_depth + 20).each do |tree_depth|
        render_shopkeeeper_children_body(shopkeeper: shopkeeper, tree_depth: tree_depth)
        xlsx_package_ws.add_row []
      end
    end
  end

  def tree_head_names
    %w(
      层级 店主姓名 省份 城市 店铺名称
      创建时间 店铺等级 手机号码 总收入 账户余额
      直接邀请总数 邀请人姓名 邀请人号码
    )
  end

  private
  def render_shopkeeeper_children_body(shopkeeper: ,tree_depth: )
    records = shopkeeper.descendant_entities.preload(:shop, :parent).with_tree_depth(
      tree_depth, operator: "="
    ).order("invite_user_id")

    if records.present?
      self.progress = (47 * tree_depth / 20).round(2)
      self.gap_progress = 2
      send_to_message

      records.each{|record|
        xlsx_package_ws.add_row [
          record.tree_depth, record.user_name,
          record.province, record.city, record.shop.to_s,
          record.created_at, record.user_grade_i18n,
          record.user_phone, record.total_income_amount,
          record.balance_amount, record.children_size,
          record.parent.try(:user_name), record.parent.try(:user_phone)
        ]
      }
    end
  end
end