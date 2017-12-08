module SesameMall::Seekable
  extend ActiveSupport::Concern

  included do
    include SesameMall::SeekHookable

    attr_accessor :source_data, :batch_size, :primary_key, :source_primary_key

    def primary_key
      @primary_key ||= :id
    end

    def source_primary_key
      @source_primary_key ||= :id
    end
  end



  def do_whole_sync(relation: , key: nil)
    key ||= primary_key
    self.batch_size ||= 1000

    relation.in_batches(of: batch_size) {|records|
      self.source_data = records

      process
    }
  end

  def do_partial_sync(relation: )
    self.batch_size ||= 1000

    relation.in_batches(of: batch_size){|records|
      self.source_data = records

      process
    }
  end

  def process
    self.batch_size ||= 50

    before_process_hooks.map{|name|
      send(name)
    } if before_process_hooks.present?

    source_data.pluck_h.each_slice(batch_size) {|hashes|
      record_ids = hashes.pluck(source_primary_key)
      _exists_records = fetch_records(ids: record_ids)

      _records = hashes.map{|data|
        _record = _exists_records.find{|c| c.send(primary_key).to_s == data[source_primary_key].to_s}

        to_model(data, record: _record)
      }

      ActiveRecord::Base.transaction do
        _records.each {|record|
          next if record.changes.except(:updated_at, :created_at).blank?

          record.save rescue nil
        }
      end
    }
  end

  private
  def parse_no_timezone(datetime: )
    datetime.is_a?(ActiveSupport::TimeWithZone) ? (datetime - datetime.utc_offset).utc : datetime
  end
  module ClassMethods
    def source_records_from_seek_record(klass: , duration: )
      _records = seek_records(duration: duration, table_name: klass.table_name)

      klass.where(
        klass.primary_key => _records.select(:primary_key_value)
      )
    end
    def seek_records(duration: , table_name: )
      _time = Time.now

      SesameMall::Source::SeekRecord.where(
        table_name: table_name,
        created_at: duration.ago(_time).._time
      )
    end
  end
end