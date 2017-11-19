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
        source: ::Channel.sources_i18n
      },
      order: {
        order_status: ::Order.order_statuses_i18n,
        order_type: ::Order.order_types_i18n,
        ref_type: ::Order.ref_types_i18n,
        comm_setted: ::Order.comm_setteds_i18n,
        payed_push: ::Order.payed_pushes_i18n,
        global_freight_flag: ::Order.global_freight_flags_i18n,
      },
      shopkeeper: {
        user_grade: ::Shopkeeper.user_grades_i18n
      }
    }
  end
end
