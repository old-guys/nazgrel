class Api::Web::Report::ChannelShopActivitiesController < Api::Web::BaseController
  include ActionSearchable
  include ActionExportable

  def index
    _report_date = range_within_date(str: index_params[:report_date])
    @records = ReportChannelShopActivity.where(
      report_date: _report_date
    ).preload(channel: :channel_users)

    if index_params[:channel_id].present?
      @records = @records.where(channel_id: index_params[:channel_id])
    end

    @records = filter_by_pagination(relation: @records)
  end

  def report
    @time_type = report_params[:time_type]

    if @time_type == "day"
      report_by_time_type_day(report_date: report_params[:report_date], channel_id: report_params[:channel_id])
    end
    if @time_type == "month"
      report_date = Date.parse(report_params[:report_date]).all_month rescue nil
      report_by_time_type_month(report_date: report_date, channel_id: report_params[:channel_id])
    end
  end

  private
  def index_params
    _params = params.permit(
      :channel_id,
      :report_date,
      report_date: []
    )

    _params
  end

  def report_params
    _params = params.permit(
      :time_type,
      :channel_id,
      :report_date
    )
    _params[:time_type] ||= "day"

    _params
  end

  def report_by_time_type_day(report_date: Date.today, channel_id: nil)
    @records = ReportChannelShopActivity.where(
      report_date: report_date
    ).preload(channel: :channel_users)
    @records= @records.where(channel_id: channel_id) if channel_id.present?

    preload_export(service: 'ChannelShopActivity', action: 'report', relation: @records, **report_params.to_h.symbolize_keys)

    @records = filter_by_pagination(relation: @records)
    @records
  end

  def report_by_time_type_month(report_date: Date.today.all_month, channel_id: nil)
    @records = ReportChannelShopActivity.where(
      report_date: report_date
    ).group(:channel_id)

    @records = @records.where(
      channel_id: channel_id
    ) if channel_id.present?

    preload_export(
      service: 'ChannelShopActivity',
      action: 'report',
      relation: @records,
      user_id: current_user.try(:id),
      **report_params.to_h.symbolize_keys
    )

    @records = filter_by_pagination(relation: @records)
    _sum_proc = proc {|field|
      [
        "sum(#{field}) as #{field}",
        "sum(stage_1_#{field}) as stage_1_#{field}",
        "sum(stage_2_#{field}) as stage_2_#{field}",
        "sum(stage_3_#{field}) as stage_3_#{field}",
        "max(week_#{field}) as week_#{field}",
        "max(month_#{field}) as month_#{field}",
        "max(year_#{field}) as year_#{field}",
      ]
    }
    _fields_sql = [
      "channel_id"
    ]

    ReportChannelShopActivity.stat_categories.each {|field|
      _fields_sql.concat(_sum_proc.call(field))
    }

    @record_list = @records.pluck_s(*_fields_sql)
    @channel_list = ::Channel.preload(:channel_users).where(id: @record_list.pluck(:channel_id))
  end
end