class ChannelShopActivity::UpdateReport
  class << self
    def update_report(channel: , report_date: Date.today, force_update: false, interval_time: 30.minutes)
      report_shop_activities = ReportShopActivity.where(
        shop_id: channel.shops,
        report_date: report_date
      )
      _record = ReportChannelShopActivity.where(
        channel: channel,
        report_date: report_date
      ).first_or_initialize
      _time = Time.now

      return if not force_update and _record.persisted? and (_record.updated_at + interval_time) >= _time

      _report = ChannelShopActivity::UpdateReport.new(
        report_date: report_date,
        record: _record,
        channel: channel,
        report_shop_activities: report_shop_activities
      )

      _report.perform
    end

    def insert_to_partial_channel(id: )
      _key = CHANNEL_IDS_CACHE_KEY

      Array.wrap(id).uniq.each {|c|
        $redis.SADD(_key, c) if c.present?
      }
    end
  end
  include ChannelShopActivity::Calculations
  include ReportLoggerable
  include ReportCalculationable

  CHANNEL_IDS_CACHE_KEY = "channel_shop_activity_report_channel_ids"

  attr_accessor :date, :channel, :record, :result, :report_shop_activities

  def initialize(report_date: ,record: ,channel: ,report_shop_activities: )
    self.record = record
    self.channel = channel
    self.report_shop_activities = report_shop_activities

    self.date = record.report_date
  end

  def perform
    begin
      process

      write if @result.present?
    rescue => e
      logger.warn "update report failure #{e}, record: #{record.try(:attributes)}"
      log_error(e)
    end
  end

  private
  def process
    @result = calculate(report_shop_activities: report_shop_activities)

    record.assign_attributes(
      @result
    )
  end
  def write
    record.has_changes_to_save? ? record.save : record.touch
  end

  private
end