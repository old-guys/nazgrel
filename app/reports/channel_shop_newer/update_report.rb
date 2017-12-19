class ChannelShopNewer::UpdateReport
  class << self
    def update_report(channels: , report_date: Date.today)
      _records = ReportChannelShopNewer.where(
        channel: channels,
        report_date: report_date
      ).find_each.to_a

      channels.each {|channel|
        _record = _records.find{|record|
          record.channel_id == channel.id
        }
        if _record.blank?
          _report = ChannelShopNewer::ResetReport.new(channel: channel, dates: report_date.all_year)
          _report.perform
        end
      }

      _recent_records = ReportChannelShopNewer.where(
        channel: channels,
        report_date: report_date.yesterday
      ).find_each.to_a

      _records.each {|_record|
        _recent_record = _recent_records.find{|_recent_record|
          _recent_record.channel_id == _record.channel_id
        }
        next if _recent_record.blank?
        logger.info "update report for channel_id: #{_record.channel_id}"

        _report = ChannelShopNewer::UpdateReport.new(
          recent_record: _recent_record,
          record: _record
        )

        _report.perform
      }
    end
  end
  include ChannelShopNewer::Calculations
  include ReportLoggerable

  attr_accessor :channel, :dates, :recent_record, :record, :result

  def initialize(recent_record: , record: )
    self.recent_record = recent_record
    self.record = record

    self.channel = record.channel
    self.dates = record.report_date.all_day
  end

  def perform
    begin
      @result = calculate_by_day(channel: channel, dates: dates).shift

      process

      write
    rescue => e
      logger.warn "update report failure #{e}, record: #{record.try(:attributes)}"
    end
  end

  private
  def process
    _today_grade_platinum = @result[:result].slice(
      :stage_1_grade_platinum,
      :stage_2_grade_platinum,
      :stage_3_grade_platinum
    ).values.flatten.sum
    _today_grade_gold = @result[:result].slice(
      :stage_1_grade_gold,
      :stage_2_grade_gold,
      :stage_3_grade_gold
    ).values.flatten.sum

    record.assign_attributes(
      @result[:result]
    )

    if recent_record.report_date.month == record.report_date.month
      record.assign_attributes(
        month_grade_platinum: recent_record.month_grade_platinum + _today_grade_platinum,
        month_grade_gold: recent_record.month_grade_gold + _today_grade_gold
      )
    else
      record.assign_attributes(
        month_grade_platinum: _today_grade_platinum,
        month_grade_gold: _today_grade_gold
      )
    end

    record.assign_attributes(
      year_grade_platinum: recent_record.year_grade_platinum + _today_grade_platinum,
      year_grade_gold: recent_record.year_grade_gold + _today_grade_gold
    )
  end
  def write
    record.changed? && record.save
  end
end