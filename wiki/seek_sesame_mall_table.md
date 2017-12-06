## 拉取芝麻城数据

### 模块说明

- 源数据模型(app/seeks/sesame_mall/source)
- seek (app/seeks/sesame_mall/)
- trigger_service(app/seeks/trigger_service.rb)
- seek worker
- seek_record

### 处理过程

定义源数据模型

```ruby
module SesameMall::Source
  class Order < Base
    self.table_name = :s_app_order
  end
end
```

定义 seeker（全量，增量）

```ruby
class SesameMall::OrderSeek
  include SesameMall::Seekable

  def initialize(opts = {})
    self.primary_key = :order_no
    self.source_primary_key = :order_no
  end

  # skip ...

  class << self
    def whole_sync
      seek = self.new

      seek.do_whole_sync(relation: SesameMall::Source::Order, key: :shop_id)
    end

    def partial_sync(duration: 30.minutes)
      seek = self.new
      _relation = source_records_from_seek_record(klass: SesameMall::Source::Order, duration: duration)

      seek.do_partial_sync(relation: _relation)
    end
  end
```

添加触发器

```ruby
TriggerService.setup_trigger klass: klass
```

定时队列

```ruby
# head -n 5 app/workers/order_seek_worker.rb
class OrderSeekWorker
  include Sidekiq::Worker
  sidekiq_options queue: :seek, retry: false, backtrace: true

  def perform
```

```yaml
# head -n 5 config/schedule.yml
shop_seek_job:
  cron: "*/5 * * * *"
  name: "同步店铺"
  class: "ShopSeekWorker"
  queue: :seek
```

定时清理 seek record

```ruby
# config/schedule.rb
every 2.weeks do
  runner "SesameMall::Source::SeekRecord.prune_old_records"
end
```
