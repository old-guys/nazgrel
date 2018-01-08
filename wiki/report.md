# BI 报表

## 模块说明

- 报表模型(app/models/reports/)
- 计算报表服务 (app/reports/)
- 报表服务公共模块 (app/reports/concerns)
- 计算报表 worker (app/workers/reports/)

## 渠道新增店主报表

### 处理过程

定义源数据模型

```ruby
# app/models/reports/report_channel_shop_newer.rb
class ReportChannelShopNewer < ApplicationRecord
  belongs_to :channel, required: false
```

定义计算报表服务

```shell
tree app/reports/channel_shop_newer
├── app/reports/channel_shop_newer/calculations.rb
├── app/reports/channel_shop_newer/reporting.rb
├── app/reports/channel_shop_newer/reset_report.rb
└── app/reports/channel_shop_newer/update_report.rb
```

报表服务

```ruby
class ChannelShopNewer::Reporting
  class << self
    delegate :update_report, to: "ChannelShopNewer::UpdateReport"
    delegate :reset_report, to: "ChannelShopNewer::ResetReport"
  end
end
```

计算模块

```ruby
module ChannelShopNewer::Calculations
```

重置报表

```ruby
class ChannelShopNewer::ResetReport
```

更新报表

```ruby
class ChannelShopNewer::UpdateReport
```

定时队列

```ruby
# head -n 5 app/workers/reports/channel_shop_newer_report_worker.rb
class ChannelShopNewerReportWorker
  include Sidekiq::Worker
  include ReportWorkable

  sidekiq_options queue: :report, retry: false, backtrace: true
```

```yaml
channel_shop_newer_report:
  cron: "51 11,23 * * *"
  name: "全量当天更新渠道新增报表"
  class: "ChannelShopNewerReportWorker"
  queue: :report
  args:
    type: "whole"
channel_shop_newer_report_partial:
  cron: "*/30 * * * *"
  name: "实时更新渠道新增报表"
  class: "ChannelShopNewerReportWorker"
  queue: :report
  args:
    type: "partial"
```

定时清理 seek record

```ruby
# config/schedule.rb
every 2.months do
  runner "ReportChannelShopNewer.prune_old_records"
end
```

### 更新机制

- 新增店铺之后应该触发报表更新机制
- 新增渠道之后应该触发报表更新机制
- 每隔一段时间触发一次当天渠道报表的更新

## 店主行为分析报表

### 处理过程

定义源数据模型

```ruby
# head -n 3 app/models/reports/report_shop_activity.rb
class ReportShopActivity < ApplicationRecord
  belongs_to :shop, required: false
```

定义计算报表服务

```shell
tree app/reports/shop_activity
app/reports/shop_activity
├── calculations.rb
├── reporting.rb
└── update_report.rb
```

报表服务

```ruby
class ShopActivity::Reporting
  class << self
    delegate :update_report, to: "ShopActivity::UpdateReport"
  end
end
```

计算模块

```ruby
module ShopActivity::Calculations
```

更新报表

```ruby
class ShopActivity::UpdateReport
```

定时队列

```ruby
# head -n 5 app/workers/reports/shop_activity_report_worker.rb
class ShopActivityReportWorker
  include Sidekiq::Worker
  include ReportWorkable

  sidekiq_options queue: :report, retry: false, backtrace: true
```

```yaml
shop_activity_report:
  cron: "31 10,23 * * *"
  name: "全量当天更新店主行为报表"
  class: "ShopActivityReportWorker"
  queue: :report
  args:
    type: "whole"
shop_activity_report_partial:
  cron: "*/30 * * * *"
  name: "实时更新店主行为数据"
  class: "ShopActivityReportWorker"
  queue: :report
  args:
    type: "partial"
```

定时清理 seek record

```ruby
# config/schedule.rb
every 2.months do
  runner "ReportShopActivity.prune_old_records"
end
```

### 更新机制

- 更新店铺之后应该触发报表更新机制
- 更新店主之后应该触发报表更新机制
- 每隔一段时间触发一次报表的更新

## 城市店主行为分析报表

### 处理过程

定义源数据模型

```ruby
# head -n 3 app/models/reports/report_city_shop_activity.rb
class ReportCityShopActivity < ApplicationRecord
```

定义计算报表服务

```shell
tree app/reports/city_shop_activity
app/reports/city_shop_activity
├── calculations.rb
├── reporting.rb
└── update_report.rb
```

报表服务

```ruby
class CityShopActivity::Reporting
  class << self
    delegate :update_report, to: "CityShopActivity::UpdateReport"
  end
end
```

计算模块

```ruby
module CityShopActivity::Calculations
```

更新报表

```ruby
class CityShopActivity::UpdateReport
```

定时队列

```ruby
# head -n 5 app/workers/reports/city_shop_activity_report_worker.rb
class CityShopActivityReportWorker
  include Sidekiq::Worker
  include ReportWorkable

  sidekiq_options queue: :report, retry: false, backtrace: true
```

```yaml
city_shop_activity_report:
  cron: "41 11,23 * * *"
  name: "全量当天更新城市店主行为报表"
  class: "CityShopActivityReportWorker"
  queue: :report
  args:
    type: "whole"
city_shop_activity_report_partial:
  cron: "*/30 * * * *"
  name: "实时更新城市店主行为数据"
  class: "CityShopActivityReportWorker"
  queue: :report
  args:
    type: "partial"
```

定时清理 seek record

```ruby
# config/schedule.rb
every 2.months do
  runner "ReportCityShopActivity.prune_old_records"
end
```

### 更新机制

- 更新店铺之后应该触发城市报表更新机制