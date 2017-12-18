class Api::Web::ConstantSettingController < Api::Web::BaseController
  skip_before_action :authenticate!, raise: false

  def index
    @data = {
      foo: "foo"
    }
  end

  def enum_field
    @data = {
      channel: {
        category: ::Channel.categories_i18n,
        source: ::Channel.sources_i18n,
        status: ::Channel.statuses_i18n,
      },
      channel_user: {
        role_type: ::ChannelUser.role_types_i18n,
      },
      channel_region: {
        status: ::ChannelRegion.statuses_i18n,
      },
      order: {
        order_status: ::Order.order_statuses_i18n,
        order_type: ::Order.order_types_i18n,
        ref_type: ::Order.ref_types_i18n,
        comm_setted: ::Order.comm_setteds_i18n,
        payed_push: ::Order.payed_pushes_i18n,
        global_freight_flag: ::Order.global_freight_flags_i18n,
      },
      order_detail: {
        is_free_delivery: ::OrderDetail.is_free_deliveries_i18n,
        product_label_type: ::OrderDetail.product_label_types_i18n,
      },
      order_sub: {
        order_status: ::OrderSub.order_statuses_i18n,
        shop_user_deliveried_push: ::OrderSub.shop_user_deliveried_pushes_i18n,
        user_deliveried_push: ::OrderSub.user_deliveried_pushes_i18n,
        supplier_deliveried_push: ::OrderSub.supplier_deliveried_pushes_i18n,
        is_zone_freight: ::OrderSub.is_zone_freights_i18n,
      },
      product: {
        status: ::Product.statuses_i18n,
        is_pinkage: ::Product.is_pinkages_i18n,
        label_type: ::Product.label_types_i18n
      },
      product_shop: {
        status: ::ProductShop.statuses_i18n,
      },
      income_record: {
        source_user_level: ::IncomeRecord.source_user_levels_i18n,
        income_type: ::IncomeRecord.income_types_i18n,
        status: ::IncomeRecord.statuses_i18n,
      },
      shopkeeper: {
        user_grade: ::Shopkeeper.user_grades_i18n
      },
      shop_user: {
        sex: ::ShopUser.sexes_i18n,
        verify_flag: ::ShopUser.verify_flags_i18n,
        status: ::ShopUser.statuses_i18n,
        source: ::ShopUser.sources_i18n,
        shopkeeper_flag: ::ShopUser.shopkeeper_flags_i18n,
        wechat_flag: ::ShopUser.wechat_flags_i18n,
      },
      shop_wechat_user: {
        gender: ::ShopWechatUser.genders_i18n,
        status: ::ShopWechatUser.statuses_i18n
      },
      supplier: {
        status: ::Supplier.statuses
      }
    }
  end
end