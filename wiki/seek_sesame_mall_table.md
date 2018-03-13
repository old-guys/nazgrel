## 拉取芝蚂城数据

### 模块说明

- 源数据模型(app/seeks/sesame_mall/source)
- seek (app/seeks/sesame_mall/)
- trigger_service(app/seeks/trigger_service.rb)
- seek worker (app/workers/seeks/)
- seek_record(app/seeks/sesame_mall/source/seek_record.rb)

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

seeker hook

```shell
class SesameMall::ShopSeek
  include SesameMall::Seekable
  before_process :process_shopkeeper
  after_process :after_process_shopkeeper

  def process_shopkeeper
  end

  def after_process_shopkeeper(records: )
  end
end
```

添加触发器

```ruby
TriggerService.setup_trigger klass: klass
```

定时队列

```ruby
# head -n 5 app/workers/seeks/order_seek_worker.rb
class OrderSeekWorker
  include Sidekiq::Worker
  sidekiq_options queue: :seek, retry: false, backtrace: true

  def perform
```

```yaml
# head -n 5 config/schedule.yml
shop_seek_job:
  cron: "*/2 * * * *"
  name: "同步店铺"
  class: "ShopSeekWorker"
  queue: :seek
  args:
    duration: 3
```

清除芝蚂城已经移除的记录

```ruby
# head -n 5 app/workers/seeks/deleted_record_seek_worker.rb
class DeletedRecordSeekWorker
  include Sidekiq::Worker
  include SeekWorkable

  sidekiq_options queue: :seek, retry: false, backtrace: true
```

```ruby
head -n 5 app/seeks/sesame_mall/deleted_record_seek.rb
class SesameMall::DeletedRecordSeek
  include SesameMall::SeekLoggerable
```

```yaml
deleted_record_seek_job:
  cron: "3 * * * *"
  name: "删除芝蚂城已经删除的记录"
  class: "DeletedRecordSeekWorker"
  queue: :seek
  args:
    duration: 125
```

定时清理 seek record

```ruby
# config/schedule.rb
every 2.weeks do
  runner "SesameMall::Source::SeekRecord.prune_old_records"
end
```