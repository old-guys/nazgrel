module SesameMall::Seekable
  extend ActiveSupport::Concern

  included do
    include SesameMall::SeekHookable
    include SesameMall::SeekLoggerable

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
    logger.info "start sync:"
    _synced_count = 0

    relation.in_batches(of: batch_size) {|records|
      self.source_data = records.pluck_h

      process

      _synced_count += source_data.size
    }
    logger.info "sync finished: #{_synced_count} synced"
  end

  def do_partial_sync(relation: )
    self.batch_size ||= 1000
    logger.info "start sync:"
    _synced_count = 0

    relation.in_batches(of: batch_size){|records|
      self.source_data = records.pluck_h

      process

      _synced_count += source_data.size
    }
    logger.info "sync finished: #{_synced_count} synced"
  end

  def process
    self.batch_size ||= 100

    before_process_hooks.map{|name|
      send(name)
    } if before_process_hooks.present?

    source_data.each_slice(batch_size) {|hashes|
      record_ids = hashes.pluck(source_primary_key)
      _exists_records = fetch_records(ids: record_ids)

      _records = hashes.map{|data|
        _record = _exists_records.find{|c| c.send(primary_key).to_s == data[source_primary_key].to_s}

        to_model(data, record: _record)
      }

      _save_records = _records.reject{|record|
        record.changes.except(:updated_at, :created_at).blank?
      }

      ActiveRecord::Base.transaction do
        _save_records.each {|record|
          begin
            record.save!
          rescue => e
            logger.warn "save failure: #{e} #{record.errors}"
            log_error(e)
          end
        }
      end if _save_records.present?

      after_process_hooks.map{|name|
        send(name, records: _records.select(&:saved_changes?))
      } if after_process_hooks.present?
    }
  end

  private
  def parse_no_timezone(datetime: )
    datetime.is_a?(ActiveSupport::TimeWithZone) ? (datetime - datetime.utc_offset).utc : datetime
  end

  module ClassMethods
    def source_records_from_seek_record(klass: , duration: )
      _primary_keys = source_record_ids(duration: duration, table_name: klass.table_name)

      if _primary_keys.present?
        klass.where(
          :"#{klass.primary_key}" => _primary_keys
        )
      else
        klass.none
      end
    end

    private
    def source_record_ids(duration: , table_name: )
      if duration <= 5.minutes
        seek_record_ids_pool(duration: duration, table_name: table_name)
      else
        seek_record_ids(duration: duration, table_name: table_name)
      end
    end

    def seek_record_ids(duration: , table_name: )
      _datetimes = duration.ago.beginning_of_minute..Time.now.end_of_minute

      SesameMall::Source::SeekRecord.where(
        table_name: table_name,
        created_at: _datetimes
      ).pluck(:primary_key_value)
    end

    # NOTICE use cached value (all seek record group by table_name) duration every minute
    def seek_record_ids_pool(duration: , table_name: )
      _datetimes = duration.ago.beginning_of_minute..Time.now.end_of_minute
      _cache_key = "seek_records_pool:#{duration}" << Digest::MD5.hexdigest(_datetimes.to_s)

      _seek_records_pool = Rails.cache.fetch(_cache_key, expires_in: 5.minutes) do
        _records = SesameMall::Source::SeekRecord.where(
          created_at: _datetimes
        )

        _records.pluck_s(:table_name, :primary_key_value).inject({}) {|memo, values|
          memo[values.table_name] ||= []
          memo[values.table_name] << values.primary_key_value

          memo
        }
      end

      _seek_records_pool[table_name]
    end
  end
end