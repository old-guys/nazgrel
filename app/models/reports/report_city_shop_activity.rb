class ReportCityShopActivity < ApplicationRecord

  class << self
    def prune_old_records
      where("`report_date` <= ?", 24.months.ago).in_batches(of: 10000) {|records|
        records.delete_all

        sleep 0.5
      }
    end
  end
end