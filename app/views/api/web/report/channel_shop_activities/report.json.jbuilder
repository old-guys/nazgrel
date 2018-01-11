if @time_type == "day"
  json.partial! 'api/web/report/channel_shop_activities/time_type_day_summary',
    locals: {records: @records}

  json.partial! 'api/shared/paginator', records: @records
  json.models do
    json.cache_collection! @records.map.with_index(1).to_a, key: proc {|record, index|
        ['api/web/report/channel_shop_activities/report#day', [record, record.channel]]
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
        *ReportChannelShopActivity.stat_fields
      )

      json.ecn_count record.ecn_grade_platinum_count.to_i + record.ecn_grade_gold_count.to_i
    end
  end
end
if @time_type == "month"
  json.partial! 'api/web/report/channel_shop_activities/time_type_month_summary',
    locals: {records: @records}

  json.partial! 'api/shared/paginator', records: @records
  json.models do
    json.cache_collection! @record_list.map.with_index(1).to_a, key: proc {|record, index|
        [
          'api/web/report/channel_shop_activities/report#month', [
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
        *ReportChannelShopActivity.stat_fields
      )
      json.ecn_count record.ecn_grade_platinum_count.to_i + record.ecn_grade_gold_count.to_i
    end
  end
end