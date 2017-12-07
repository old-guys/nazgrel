# 芝麻城 BI 架构

本文档目的是描述有关组织和架构芝麻城 BI 的一些约定和规范。

首先我们给出 BI 的一些基本概念，以便于后续内容的展开。

## BI 组件

BI 由不断增长的组件构成，其中包括：

* 多维聚合和分配
* 非规范化，标签和标准化
* 实时报告分析报警
* 与非结构化数据源接口的方法
* 分组合并，预算和滚动预测
* 统计推断和概率模拟
* 关键性能指标优化
* 版本控制和过程管理
* 开放项目管理

## BI 的商业目的

商业智能可以应用于以下商业目的，以推动商业价值。

1. 测量 —— 程序，创建性能指标的层次结构（另请参阅度量标准参考模型）和基准测试，通知商业领袖实现
  商业目标（业务流程管理）。
2. 分析 —— 为企业建立量化过程的程序达成最佳决策并执行业务知识发现。经常涉及：数据挖掘，流程挖掘
  统计分析，预测分析，预测建模，业务流程建模，数据沿袭，复杂的事件处理和规定性分析。
3. 报告/企业报告 —— 为战略构建基础架构的计划报告服务于企业的战略管理，而不是业务报告。经常涉及
  数据可视化，执行信息系统和OLAP。
4. 协作/协作平台 —— 程序获得不同领域（业务内外）通过数据共享和共同合作电子数据交换。
5. 知识管理 —— 程序使公司数据驱动通过战略以及识别，创建，表示，分发和实现采用的实践洞察力和经验
  是真正的商业知识。知识管理领导学习管理和合规性。

除上述之外，商业智能可以提供一个主动的方法，例如警报功能，如果条件满足立即通知最终用户。 例如，
如果一些商业指标超过了预定义该标准将在标准报告和业务中突出显示分析师可能会通过电子邮件或其他监控
服务收到提醒。 这端到端过程需要数据治理，应该由专家来处理。

## BI 可用数据的数量和质量

商业智能的质量方面应涵盖从源数据到最终报告的所有过程。在每一步，偏重是不同的：

1. 源数据:
     * 数据标准化: 使数据具有可比性（相同的单位，相同的模式...）
     * 主数据管理：独特的参考
2. 运营数据存储（ODS）：
     * 数据清理：检测并更正不准确的数据
     * 数据分析：检查不合适的值，空/空
3. 数据仓库：
     * 完整性：检查是否加载了所有预期的数据
     * 参照完整性：所有来源的独特和现有的参考
     * 来源之间的一致性：检查合并数据和来源
4. 报告：
     * 指标的唯一性：只有一个共享字典的指标
     * 配方准确性：应避免或检查本地的报告公式

## 程序职责定义

- 业务数据和 BI 数据分开
- 通过程序自动挖掘数据到 BI 源数据库
- 根据挖掘的数据生成报表数据
- 呈现报表数据给终端用户
- 根据 BI 源数据实现预警机制

## 数据分布

<pre>
  业务系统     |     BI 系统
              |
业务数据 -挖掘> | BI 源数据 -> 报表数据
              |     |
              |    预警
</pre>

## 程序实现相关约定

- 业务库 `model` 不要在 `models`
- 从业务库实时更新到 BI 数据库
- 采集的数据记录的 ID 应该和业务库的一致
- 对于采集过来的任何一张表需要保证可以重建（以应对业务数据结构变动或者系统本身数据结构的变化要求）
- 采集的数据记录应该最大原则上和业务库一致

## 程序结构

<pre>
app/models
  users/
    channel_user
  channels
    channel
    channel_shop_keeper
  sesame_mall
    shop
    shopkeeper
    责任人
    店主
    订单
    商品
  reports
    report_channel_shop_newer
    report_*
app/services
  sesame_mall
    xxx_reporter
app/seeks
  sesame_mall
lib/
  task
    sesame_mall
      seek.rake
      reporter.rake
</pre>

## 店铺和渠道关系

shop
  t.string :name, comment: "店名"
  t.integer :user_id, comment: "芝蚂城用户id"

  t.string :path, comment: "店铺邀请层级"
  t.string :channel_path, "代理商层级"

shopkeeper
  t.integer :user_id, comment: "爱上岗用户ID"
  t.string :user_name, comment: "用户姓名"
  t.string :user_phone, comment: "用户手机号"
  t.string :user_photo, comment: "用户头像"
  t.integer :user_grade, comment: "店主等级：0-白金店主，1-黄金店主，2-见习店主"

## 渠道下属层级

* 渠道上面有渠道大区
* 渠道大区可以设置大区管理
* 渠道大区可以查看所有下属渠道的数据
* 渠道下面有渠道人员
* 渠道人员分为管理员和普通用户
* 渠道人员必须是芝麻城店主
* 渠道人员的店不应该超出渠道所在根结点的所属下级店铺范围
* 渠道人员和芝麻店铺和店主是一对一关联
* 管理员可以查看渠道下属所有店铺数据
* 普通用户只能查看自己所属店铺以及邀请的数据
* 渠道和渠道之间数据不可见
* 渠道下面的店主也可以成为渠道


```shell
             channel_region(region_manager)
    channel(manager)                   channel(manager)
normal_user  normal_user      normal_user
shop         shop             shop
```

## 订单关系

* 一个订单拆分为多个子订单
* 每个子订单对应多个商品（订单详情）
* 每个子订单对应一个物流订单

## 数据权限

### 对象

渠道管理员（大区 ChannelRegion）-> channel_channel_region_maps, channel_user

渠道 Channel (固定督导 Shopkeeper, 种子店主的邀请根结点) -> channel_user#channel_id

---------------

channel 直接邀请店主

channel 间接邀请店主

### channel_user 对象

```yaml
manager: "管理员" # 固定督导, 种子店主
normal_user: "普通用户" # 固定督导下面邀请的店主
region_manager: "渠道管理员"
```

### 渠道数据示例

```shell
manager#shop
path 0 / 23 / 43(渠道，固定督导)
channel_path 0 / 43
channel_path like "0/43/%" or channel_path = "0/43/"

normal_user#shop
path 0 / 23 / 43(渠道，固定督导) / 56 / 79
channel_path 0 / 43 / 56 / 79
channel_path like "0/43/56/79/%" or channel_path = "0/43/56/79"

region_manager
  channel channel

邀请下级店主成为了渠道管理员如何处理
```