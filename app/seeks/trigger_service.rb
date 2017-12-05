class TriggerService
  class << self
    def setup(source: )
      create_seek_record_table(source: source)
    end

    def setup_trigger(klass:)
      TriggerService.new(klass: klass).setup_trigger
    end

    def delete_trigger(klass:)
      TriggerService.new(klass: klass).delete_trigger
    end

    def delete_all(source: )
      TriggerConfig.where(source: source).pluck(:model_type).each {|klass_name|
        _klass = klass_name.safe_constantize
        next if _klass.nil?

        TriggerService.delete_trigger(klass: _klass)
      }

      drop_seek_record_table(source: source)
    end

    def detect_seek_record_klass_by_source!(source: )
      case source
      when :sesame_mall
        SesameMall::Source::SeekRecord
      else
        raise "Unknown source for #{source}"
      end
    end

    private
    def drop_seek_record_table(source: )
      _klass = detect_seek_record_klass_by_source!(source: source)

      SesameMall::Source::SeekRecord.connection.execute "DROP TABLE IF EXISTS #{_klass.table_name}"
    end
    def create_seek_record_table(source: )
      _klass = detect_seek_record_klass_by_source!(source: source)

      _sql = <<~SQL
        CREATE TABLE `#{_klass.table_name}` (
          `id` bigint(20) NOT NULL AUTO_INCREMENT,
          `table_name` varchar(255) DEFAULT NULL COMMENT '表名',
          `primary_key_value` bigint(11) DEFAULT NULL COMMENT '主键记录值',
          `action` varchar(255) DEFAULT NULL COMMENT '动作',
          `created_at` datetime DEFAULT CURRENT_TIMESTAMP NOT NULL,
          PRIMARY KEY (`id`),
          KEY `index_#{_klass.table_name}_created_at` (`created_at`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='BI增量数据'
      SQL

      _klass.connection.execute _sql
    end
  end

  attr_reader :klass, :source, :seek_record_klass, :seek_klasses

  def initialize(klass:)
    @klass               = klass
    @source              = detect_source_by_klass!(klass: klass)
    @seek_record_klass   = self.class.detect_seek_record_klass_by_source!(source: source)
    @seek_klasses        = TriggerConfig.where(source: source).pluck(:model_type)
  end

  def setup_trigger
    create_insert_trigger
    create_update_trigger
    create_delete_trigger

    TriggerConfig.where(model_type: klass.to_s, source: source).first_or_create
  end

  def delete_trigger
    TriggerConfig.where(model_type: klass.to_s, source: source).delete_all
    seek_klasses.delete(klass.to_s)

    delete_setup_trigger_triggers
    seek_record_klass.where(table_name: klass.table_name).delete_all
  end

  private
  def create_insert_trigger
    _source_table = klass.table_name
    _trigger_name = "insert_#{_source_table}_seek_record"
    _target_table = seek_record_klass.table_name

    klass.connection.execute "drop trigger if exists #{_trigger_name}"

    _sql = <<~SQL
      CREATE
      TRIGGER #{_trigger_name}
      AFTER INSERT
      ON #{_source_table} FOR EACH ROW
      BEGIN
        insert into #{_target_table}(`table_name`, `primary_key_value`, `action`, `created_at`) values('#{_source_table}', NEW.`#{klass.primary_key}`, 'insert', UTC_TIMESTAMP());
      END;
    SQL
    klass.connection.execute _sql
  end

  def create_update_trigger
    _source_table = klass.table_name
    _trigger_name = "update_#{_source_table}_seek_record"
    _target_table = seek_record_klass.table_name

    klass.connection.execute "drop trigger if exists #{_trigger_name}"
    _sql = <<~SQL
      CREATE
      TRIGGER #{_trigger_name}
      AFTER UPDATE
      ON #{_source_table} FOR EACH ROW
      BEGIN
        insert into #{_target_table}(`table_name`, `primary_key_value`, `action`, `created_at`) values('#{_source_table}', NEW.`#{klass.primary_key}`, 'update', UTC_TIMESTAMP());
      END;
    SQL
    klass.connection.execute _sql
  end

  def create_delete_trigger
    _source_table = klass.table_name
    _trigger_name = "delete_#{_source_table}_seek_record"
    _target_table = seek_record_klass.table_name

    klass.connection.execute "drop trigger if exists #{_trigger_name}"
    _sql = <<~SQL
      CREATE
      TRIGGER #{_trigger_name}
      AFTER DELETE
      ON #{_source_table} FOR EACH ROW
      BEGIN
        insert into #{_target_table}(`table_name`, `primary_key_value`, `action`, `created_at`) values('#{_source_table}', OLD.`#{klass.primary_key}`, 'delete', UTC_TIMESTAMP());
      END;
    SQL
    klass.connection.execute _sql
  end

  def delete_setup_trigger_triggers
    master_table = @klass.table_name
    triggers     = [
      "insert_#{master_table}_seek_record",
      "update_#{master_table}_seek_record",
      "delete_#{master_table}_seek_record",
    ]

    triggers.each do |trigger_name|
      @klass.connection.execute "DROP TRIGGER IF EXISTS #{trigger_name}"
    end
  end

  def detect_source_by_klass!(klass: )
    case klass.name
    when /SesameMall::Source/
        :sesame_mall
      else
        raise "Unknown source for #{klass.name}"
    end
  end
end

# TriggerService.setup source: :sesame_mall
# TriggerService.delete_all source: :sesame_mall
# TriggerService.setup_trigger klass: SesameMall::Source::Order
# TriggerService.delete_trigger klass: SesameMall::Source::Order
