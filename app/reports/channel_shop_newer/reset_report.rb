class ChannelShopNewer::ResetReport
  class << self
    def reset_report(channels: , dates: Time.now.all_year)
      channels.each {|channel|
        _report = ChannelShopNewer::ResetReport.new(channel: channel, dates: dates)

        _report.perform
      }
    end
  end
  include ChannelShopNewer::Calculations
  include ReportLoggerable
  include ReportCalculationable

  attr_accessor :channel, :dates, :records, :new_records, :result

  def initialize(channel: , dates: )
    self.channel = channel
    self.dates = dates

    self.records = ReportChannelShopNewer.where(
      channel: channel, report_date: dates
    ).find_each.to_a
    self.new_records = []
  end

  def perform
    begin
      @result = calculate(channel: channel, dates: dates)

      process

      write
    rescue => e
      logger.warn "update report failure #{e}, channel: #{channel.id}, dates: #{dates}"
    end
  end

  private
  def process
    @result.each {|item|
      _record = records.find{|record|
        item[:report_date] == record.report_date
      } || ReportChannelShopNewer.new(
        channel: channel, report_date: item[:report_date]
      )

      self.new_records << _record if _record.new_record?
      _record.assign_attributes(
        item[:result]
      )
    }

    self.records.concat(new_records)
  end
  def write
    self.records.each_slice(100) {|_records|
      _records.select(&:has_changes_to_save?).map(&:save)
    }
  end
end