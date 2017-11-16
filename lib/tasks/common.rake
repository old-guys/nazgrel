# encoding: utf-8
require "logger"

def task_logger(log_file = nil)
  @log_file ||= log_file
  @log_file ||= "log/rake_#{Rails.env}.log"
  ActiveSupport::Logger.new(Rails.root.join(@log_file))
end

def simple_batch_operate(relation, batch_size: 50000, sleep_time: 0.2)
  records = relation.unscope(:order)

  _edge_ids = [records.klass.minimum(:id).to_i, records.klass.maximum(:id).to_i]
  _id = _edge_ids.first

  while
    _id_offset = _id + batch_size
    puts "_id_offset: #{_id_offset}"

    _records = records.where(id: _id.._id_offset)

    if block_given?
      yield _records

      sleep sleep_time
    end

    break if _id_offset > _edge_ids.last

    _id = _id_offset
  end
end
alias :batch_operate :simple_batch_operate
