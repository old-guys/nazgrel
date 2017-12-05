module SesameMall::Source
  class SeekRecord < Base
    self.table_name = :seek_records

    class << self
      def prune_old_records
        where("`created_at` <= ?", 1.months.ago).in_batches(of: 10000) {|records|
          records.delete_all

          sleep 0.5
        }
      end
    end
  end
end
