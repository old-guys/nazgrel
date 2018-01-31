module Export
  class ChannelShopActivityService

    include Export::BaseService

    def report_records_convert
      return records if params[:time_type].eql?('day')

      _sum_proc = proc {|field|
        [
          "sum(#{field}) as #{field}",
          "sum(stage_1_#{field}) as stage_1_#{field}",
          "sum(stage_2_#{field}) as stage_2_#{field}",
          "sum(stage_3_#{field}) as stage_3_#{field}",
          "max(month_#{field}) as month_#{field}",
          "max(year_#{field}) as year_#{field}",
        ]
      }
      _fields_sql = [
        "channel_id"
      ]

      _fields_sql.contact(
        ReportChannelShopActivity.stat_categories.map {|field|
          _sum_proc.call(field)
        }.flatten
      )

      @record_list = collection.pluck_s(*_fields_sql)
      @channel_list = ::Channel.preload(:channel_users).where(id: @record_list.pluck(:channel_id))

      @record_list.collect do |record|
        channel = @channel_list.find{|_record| _record.id == record.channel_id }
        OpenStruct.new(
          record.to_h.merge(
            channel: channel
          )
        )
      end
    end

    def report_record_ecn_count(record)
      record.ecn_grade_platinum_count.to_i + record.ecn_grade_gold_count.to_i
    end

    def report_record_channel_user_name(record)
      record.channel.channel_users.take.to_s rescue nil
    end

    def report_record_channel_name(record)
      record.channel.to_s rescue nil
    end

    def report_record_channel_city(record)
      record.channel.city rescue nil
    end

    def report_fields
      %w(
        channel_user_name channel_name channel_city ecn_count
        stage_1_shared_count stage_1_view_count stage_1_order_number stage_1_shopkeeper_order_number stage_1_sale_order_number stage_1_order_amount stage_1_shopkeeper_order_amount stage_1_sale_order_amount
        stage_2_shared_count stage_2_view_count stage_2_order_number stage_2_shopkeeper_order_number stage_2_sale_order_number stage_2_order_amount stage_2_shopkeeper_order_amount stage_2_sale_order_amount
        stage_3_shared_count stage_3_view_count stage_3_order_number stage_3_shopkeeper_order_number stage_3_sale_order_number stage_3_order_amount stage_3_shopkeeper_order_amount stage_3_sale_order_amount
        month_shared_count month_view_count month_order_number month_shopkeeper_order_number month_sale_order_number month_order_amount month_shopkeeper_order_amount month_sale_order_amount
        year_shared_count year_view_count year_order_number year_shopkeeper_order_number year_sale_order_number year_order_amount year_shopkeeper_order_amount year_sale_order_amount
      )
    end

    def write_report_day_head
      title_style = xlsx_package_wb.styles.add_style(bg_color: "996600", fg_color: "FFFFFF", sz: 14, format_code: "@",font_name: 'SimSun', alignment: {horizontal: :center})

      _records = collection.unscope(
        :limit, :offset
      )

      xlsx_package_ws.add_row [
        '合计', nil, nil,
        _records.sum("ecn_grade_gold_count").to_i + _records.sum("ecn_grade_platinum_count").to_i,
        _records.sum(:stage_1_shared_count),
        _records.sum(:stage_1_view_count),
        _records.sum(:stage_1_order_number),
        _records.sum(:stage_1_shopkeeper_order_number),
        _records.sum(:stage_1_sale_order_number),
        _records.sum(:stage_1_order_amount),
        _records.sum(:stage_1_shopkeeper_order_amount),
        _records.sum(:stage_1_sale_order_amount),

        _records.sum(:stage_2_shared_count),
        _records.sum(:stage_2_view_count),
        _records.sum(:stage_2_order_number),
        _records.sum(:stage_2_shopkeeper_order_number),
        _records.sum(:stage_2_sale_order_number),
        _records.sum(:stage_2_order_amount),
        _records.sum(:stage_2_shopkeeper_order_amount),
        _records.sum(:stage_2_sale_order_amount),

        _records.sum(:stage_3_shared_count),
        _records.sum(:stage_3_view_count),
        _records.sum(:stage_3_order_number),
        _records.sum(:stage_3_shopkeeper_order_number),
        _records.sum(:stage_3_sale_order_number),
        _records.sum(:stage_3_order_amount),
        _records.sum(:stage_3_shopkeeper_order_amount),
        _records.sum(:stage_3_sale_order_amount),

        _records.sum(:month_shared_count),
        _records.sum(:month_view_count),
        _records.sum(:month_order_number),
        _records.sum(:month_shopkeeper_order_number),
        _records.sum(:month_sale_order_number),
        _records.sum(:month_order_amount),
        _records.sum(:month_shopkeeper_order_amount),
        _records.sum(:month_sale_order_amount),

        _records.sum(:year_shared_count),
        _records.sum(:year_view_count),
        _records.sum(:year_order_number),
        _records.sum(:year_shopkeeper_order_number),
        _records.sum(:year_sale_order_number),
        _records.sum(:year_order_amount),
        _records.sum(:year_shopkeeper_order_amount),
        _records.sum(:year_sale_order_amount),
      ], style: title_style
    end

    def write_report_month_head
      title_style = xlsx_package_wb.styles.add_style(bg_color: "996600", fg_color: "FFFFFF", sz: 14, format_code: "@",font_name: 'SimSun', alignment: {horizontal: :center})

      _records = collection.unscope(
        :limit, :offset
      )

      xlsx_package_ws.add_row [
        '合计', nil, nil,
        _records.pluck("max(ecn_grade_gold_count)").sum.to_i + collection.pluck("max(ecn_grade_platinum_count)").sum.to_i,

        _records.sum(:stage_1_shared_count).values.sum,
        _records.sum(:stage_1_view_count).values.sum,
        _records.sum(:stage_1_order_number).values.sum,
        _records.sum(:stage_1_shopkeeper_order_number).values.sum,
        _records.sum(:stage_1_sale_order_number).values.sum,
        _records.sum(:stage_1_order_amount).values.sum,
        _records.sum(:stage_1_shopkeeper_order_amount).values.sum,
        _records.sum(:stage_1_sale_order_amount).values.sum,

        _records.sum(:stage_2_shared_count).values.sum,
        _records.sum(:stage_2_view_count).values.sum,
        _records.sum(:stage_2_order_number).values.sum,
        _records.sum(:stage_2_shopkeeper_order_number).values.sum,
        _records.sum(:stage_2_sale_order_number).values.sum,
        _records.sum(:stage_2_order_amount).values.sum,
        _records.sum(:stage_2_shopkeeper_order_amount).values.sum,
        _records.sum(:stage_2_sale_order_amount).values.sum,

        _records.sum(:stage_3_shared_count).values.sum,
        _records.sum(:stage_3_view_count).values.sum,
        _records.sum(:stage_3_order_number).values.sum,
        _records.sum(:stage_3_shopkeeper_order_number).values.sum,
        _records.sum(:stage_3_sale_order_number).values.sum,
        _records.sum(:stage_3_order_amount).values.sum,
        _records.sum(:stage_3_shopkeeper_order_amount).values.sum,
        _records.sum(:stage_3_sale_order_amount).values.sum,

        _records.pluck("max(month_shared_count)").sum,
        _records.pluck("max(month_view_count)").sum,
        _records.pluck("max(month_order_number)").sum,
        _records.pluck("max(month_shopkeeper_order_number)").sum,
        _records.pluck("max(month_sale_order_number)").sum,
        _records.pluck("max(month_order_amount)").sum,
        _records.pluck("max(month_shopkeeper_order_amount)").sum,
        _records.pluck("max(month_sale_order_amount)").sum,

        _records.pluck("max(year_shared_count)").sum,
        _records.pluck("max(year_view_count)").sum,
        _records.pluck("max(year_order_number)").sum,
        _records.pluck("max(year_shopkeeper_order_number)").sum,
        _records.pluck("max(year_sale_order_number)").sum,
        _records.pluck("max(year_order_amount)").sum,
        _records.pluck("max(year_shopkeeper_order_amount)").sum,
        _records.pluck("max(year_sale_order_amount)").sum,
      ], style: title_style
    end

    def write_report_head
      send("write_report_#{params[:time_type]}_head")

      title_style = xlsx_package_wb.styles.add_style(bg_color: "996600", fg_color: "FFFFFF", sz: 14, format_code: "@",font_name: 'SimSun', alignment: {horizontal: :center})
      xlsx_package_ws.add_row [
        '责任人', '所属渠道', '所在城市', 'ENC总数',
        '00：00至09：00', nil, nil, nil, nil, nil, nil, nil,
        '09：00至18：00', nil, nil, nil, nil, nil, nil, nil,
        '18：00至24：00', nil, nil, nil, nil, nil, nil, nil,
        '本月累计', nil, nil, nil, nil, nil, nil, nil,
        '本年累计', nil, nil, nil, nil, nil, nil, nil,
      ], style: title_style

      xlsx_package_ws.add_row [
        nil, nil, nil, nil,
        '分享数', '浏览量', '订单总数', '自购订单数', '销售订单数', '订单总金额', '自购订单总金额', '销售订单总金额',
        '分享数', '浏览量', '订单总数', '自购订单数', '销售订单数', '订单总金额', '自购订单总金额', '销售订单总金额',
        '分享数', '浏览量', '订单总数', '自购订单数', '销售订单数', '订单总金额', '自购订单总金额', '销售订单总金额',
        '分享数', '浏览量', '订单总数', '自购订单数', '销售订单数', '订单总金额', '自购订单总金额', '销售订单总金额',
        '分享数', '浏览量', '订单总数', '自购订单数', '销售订单数', '订单总金额', '自购订单总金额', '销售订单总金额',
      ], style: title_style

      xlsx_package_ws.merge_cells("E2:L2")
      xlsx_package_ws.merge_cells("M2:T2")
      xlsx_package_ws.merge_cells("U2:AB2")
      xlsx_package_ws.merge_cells("AC2:AJ2")
      xlsx_package_ws.merge_cells("AK2:AR2")
    end

  end
end