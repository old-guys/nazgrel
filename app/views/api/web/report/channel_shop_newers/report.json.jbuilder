if @time_type == "day"
  json.partial! 'api/web/report/channel_shop_newers/time_type_day_summary',
    locals: {records: @records}

  json.partial! 'api/shared/paginator', records: @records
  json.models do
    json.cache_collection! @records.map.with_index(1).to_a, key: proc {|record, index|
        ['api/web/report/channel_shop_newers/report#day', [record, record.channel]]
      } do |record, index|
      json.index index

      json.channel_id record.channel_id
      json.channel({})
      json.channel do
        json.name record.channel.to_s
        json.channel_user_name record.channel.channel_users.take.to_s
        json.city record.channel.city
      end

      json.(record,
        :stage_1_grade_platinum, :stage_1_grade_gold,
        :stage_2_grade_platinum, :stage_2_grade_gold,
        :stage_3_grade_platinum, :stage_3_grade_gold,
        :month_grade_platinum, :month_grade_gold,
        :year_grade_platinum, :year_grade_gold,
      )
    end
  end
end
if @time_type == "month"
  json.partial! 'api/web/report/channel_shop_newers/time_type_month_summary',
    locals: {records: @records}

  json.partial! 'api/shared/paginator', records: @records
  json.models do
    json.cache_collection! @record_list.map.with_index(1).to_a, key: proc {|record, index|
        [
          'api/web/report/channel_shop_newers/report#month', [
            record,
            @channel_list.find{|_record|
              _record.id == record.channel_id
            }
          ]
        ]
      } do |record, index|
      json.index index

      json.channel_id record.channel_id
      json.channel({})
      json.channel do
        _channel = @channel_list.find{|_record| _record.id == record.channel_id}
        if _channel.present?
          json.name _channel.to_s
          json.channel_user_name _channel.channel_users.take.to_s
          json.city _channel.city
        end
      end

      json.(record,
        :stage_1_grade_platinum, :stage_1_grade_gold,
        :stage_2_grade_platinum, :stage_2_grade_gold,
        :stage_3_grade_platinum, :stage_3_grade_gold,
        :month_grade_platinum, :month_grade_gold,
        :year_grade_platinum, :year_grade_gold,
      )
    end
  end
end