class Api::Web::Report::ChannelShopNewersController < Api::Web::BaseController
  include ActionSearchable

  def index
    _report_date = range_within_date(str: index_params[:report_date])
    @records = ReportChannelShopNewer.where(
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
    @records = ReportChannelShopNewer.where(
      report_date: report_date
    ).preload(channel: :channel_users)
    @records= @records.where(channel_id: channel_id) if channel_id.present?
    @records = filter_by_pagination(relation: @records)

    @records
  end

  def report_by_time_type_month(report_date: Date.today.all_month, channel_id: nil)
    @channels = ::Channel.normal
    @channels = @channels.where(id: channel_id) if channel_id.present?

    @records = ReportChannelShopNewer.where(
      report_date: report_date,
      channel: @channels
    ).group(:channel_id)
    @records = filter_by_pagination(relation: @records)
    @record_list = @records.pluck_s(
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
  end
end