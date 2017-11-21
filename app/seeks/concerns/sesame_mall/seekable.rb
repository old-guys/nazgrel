module SesameMall::Seekable
  extend ActiveSupport::Concern

  included do
    attr_accessor :source_data, :batch_size, :primary_key

    attr_accessor :source_data

    def primary_key
      @primary_key ||= :id
    end
  end



  def do_whole_sync(relation: , key: nil)
    key ||= primary_key
    self.batch_size ||= 1000

    Utility.simple_batch_operate(relation, batch_size: batch_size, primary_key: key) {|records|
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

    source_data.pluck_h.each_slice(batch_size) {|hashes|
      record_ids = hashes.pluck(primary_key)
      _exists_records = fetch_records(ids: record_ids)

      _records = hashes.map{|data|
        _record = _exists_records.find{|c| c.send(primary_key).to_s == data[primary_key].to_s}

        to_model(data, record: _record)
      }

      ActiveRecord::Base.transaction do
        _records.each {|record|
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
  end
end
