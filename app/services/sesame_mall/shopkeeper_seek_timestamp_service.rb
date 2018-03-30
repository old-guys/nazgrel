class SesameMall::ShopkeeperSeekTimestampService
  include ActiveModel::Model

  attr_accessor :shopkeeper
  attr_reader :timestamp

  def initialize(attributes={})
    super

    @timestamp = (Rails.cache.read(cache_key) || Hash.new)
  end

  def touch(target: )
    _targets = Array.wrap(target).uniq

    _targets.each {|_target|
       _name = target_key(target: _target)

       timestamp[_name] = Time.now
    }

    Rails.cache.write(cache_key, timestamp, expire_time: 7.days)
  end

  def value(target: )
    _name = target_key(target: target)

    timestamp[_name]
  end
  private
  def cache_key
    @cache_key ||= "#{shopkeeper.cache_key}:seek_timestmap"
  end

  def target_key(target: )
    case target
      when ApplicationRecord
        target.class.table_name
      when Class
        target.table_name
      else
        target.to_s
    end
  end

  class << self
    # SesameMall::ShopkeeperSeekTimestampService.touch_timestamp(
    #   shopkeeper: Shopkeeper.first,
    #   target: [Order, IncomeRecord.last]
    # )
    def touch_timestamp(shopkeeper: , target: )
      new(shopkeeper: shopkeeper).touch(target: target)
    end
  end
end