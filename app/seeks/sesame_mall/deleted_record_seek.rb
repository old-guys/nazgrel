class SesameMall::DeletedRecordSeek
  include SesameMall::SeekLoggerable

  def initialize(opts = {})
  end

  def do_partial_sync(relation: )
    _source_klasses = deleted_record_klasses
    _deleted_records = {}

    relation.find_each{|seek_record|
      _klass = _source_klasses.find{|klass|
        seek_record.table_name == klass.table_name
      }

      if _klass
        _deleted_records[_klass.name] ||= {
          klass: _klass,
          ids: []
        }
        _deleted_records[_klass.name][:ids] << seek_record.primary_key_value
      end
    }

    _deleted_records.each{|k, hash|
      _klass = "#{k.demodulize}".safe_constantize
      next if _klass.blank?

      _seek = seek_by_klass(klass: _klass)

      if _seek and hash[:ids].present?
        logger.info "sync deleted: #{hash[:ids].length} #{_klass.name} synced"

        hash[:ids].each_slice(500) {|ids|
          _klass.where(
            _seek.new.primary_key => ids
          ).delete_all
        }
      end
    }
  end

  private
  def seek_by_klass(klass: )
    "SesameMall::#{klass.name.demodulize}Seek".safe_constantize
  end
  def deleted_record_klasses
    _exclude_klass_name = [
      :Base, :SeekRecord
    ]

    SesameMall::Source.constants.reject{|name|
      name.in?(_exclude_klass_name)
    }.map{|name|
      SesameMall::Source.const_get(name)
    }
  end
  class << self
    def partial_sync(duration: 60.minutes)
      _time = Time.now
      seek = self.new
      _relation = SesameMall::Source::SeekRecord.where(
        created_at: duration.ago(_time).._time,
        action: "delete"
      )

      seek.do_partial_sync(relation: _relation)
    end
  end
end