module Export
  class ChannelShopNewerService

    include Export::BaseService

    def report_records_convert
      return @records if params[:time_type].eql?('day')

      @record_list = collection.pluck_s(
        "channel_id",
        "sum(stage_1_grade_platinum) as stage_1_grade_platinum",
        "sum(stage_2_grade_platinum) as stage_2_grade_platinum",
        "sum(stage_3_grade_platinum) as stage_3_grade_platinum",
        "sum(stage_1_grade_gold) as stage_1_grade_gold",
        "sum(stage_2_grade_gold) as stage_2_grade_gold",
        "sum(stage_3_grade_gold) as stage_3_grade_gold",
        "max(month_grade_platinum) as month_grade_platinum",
        "max(month_grade_gold) as month_grade_gold",
        "max(year_grade_platinum) as year_grade_platinum",
        "max(year_grade_gold) as year_grade_gold",
      )

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
        channel_user_name channel_name channel_city
        stage_1_grade_platinum stage_1_grade_gold
        stage_2_grade_platinum stage_2_grade_gold
        stage_3_grade_platinum stage_3_grade_gold
        month_grade_platinum month_grade_gold
        year_grade_platinum year_grade_gold
      )
    end

    def write_report_day_head
      title_style = xlsx_package_wb.styles.add_style(bg_color: "996600", fg_color: "FFFFFF", sz: 14, format_code: "@",font_name: 'SimSun', alignment: {horizontal: :center})

      _records = self.collection.unscope(
        :limit, :offset
      )

      xlsx_package_ws.add_row [
        '合计', nil, nil,
        _records.sum(:stage_1_grade_platinum),
        _records.sum(:stage_1_grade_gold),
        _records.sum(:stage_2_grade_platinum),
        _records.sum(:stage_2_grade_gold),
        _records.sum(:stage_3_grade_platinum),
        _records.sum(:stage_3_grade_gold),
        _records.sum(:month_grade_platinum),
        _records.sum(:month_grade_gold),
        _records.sum(:year_grade_platinum),
        _records.sum(:year_grade_gold)
      ], style: title_style

      xlsx_package_ws.merge_cells("B1:C1")
    end

    def write_report_month_head
      title_style = xlsx_package_wb.styles.add_style(bg_color: "996600", fg_color: "FFFFFF", sz: 14, format_code: "@",font_name: 'SimSun', alignment: {horizontal: :center})

      _records = self.collection.unscope(
        :limit, :offset
      )

      xlsx_package_ws.add_row [
        '合计', nil, nil,
        _records.sum(:stage_1_grade_platinum).values.sum,
        _records.sum(:stage_1_grade_gold).values.sum,
        _records.sum(:stage_2_grade_platinum).values.sum,
        _records.sum(:stage_2_grade_gold).values.sum,
        _records.sum(:stage_3_grade_platinum).values.sum,
        _records.sum(:stage_3_grade_gold).values.sum,
        _records.pluck("max(month_grade_platinum)").sum,
        _records.pluck("max(month_grade_gold)").sum,
        _records.pluck("max(year_grade_platinum)").sum,
        _records.pluck("max(year_grade_gold)").sum
      ], style: title_style

      xlsx_package_ws.merge_cells("B1:C1")
    end

    def write_report_head
      send("write_report_#{params[:time_type]}_head")

      title_style = xlsx_package_wb.styles.add_style(bg_color: "996600", fg_color: "FFFFFF", sz: 14, format_code: "@",font_name: 'SimSun', alignment: {horizontal: :center})
      xlsx_package_ws.add_row ['责任人', '所属渠道', '所在城市', '00：00至09：00', nil, '09：00至18：00', nil, '18：00至24：00', nil, '本月累计', nil, '本年累计', nil], style: title_style
      xlsx_package_ws.add_row [nil, nil, nil, '白', '黄', '白', '黄', '白', '黄', '白', '黄', '白', '黄'], style: title_style

      xlsx_package_ws.merge_cells("D2:E2")
      xlsx_package_ws.merge_cells("F2:G2")
      xlsx_package_ws.merge_cells("H2:I2")
      xlsx_package_ws.merge_cells("J2:K2")
      xlsx_package_ws.merge_cells("L2:M2")
    end

  end
end