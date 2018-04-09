## 每日运营店主等级汇总报表 (2018-04-09)

- #feature# 每日运营店主等级汇总报表

```shell
cap production deploy:runrake task=data_migrations:version:v1_1_3_19_migrate_daily_operational_shop_grade_summary
```

## 商品复购率/用户留存率-优化 (2018-04-09)

- #feature# 商品复购率/用户留存率-优化

```shell
cap production deploy:runrake task=data_migrations:version:v1_1_3_18_migrate_product_repurchase_shop_retention
```

## 同步退款数据 (2018-04-04)

- #seek# 订单详情更新芝蚂城新增字段
- #seek# 芝蚂城同步退款订单
- #seek# 芝蚂城同步退款子订单
- #seek# 芝蚂城同步退款支付记录
- #seek# 芝蚂城同步退款物流订单
- #seek# 芝蚂城同步退款订单图片

```shell
cap production deploy:runrake task=data_migrations:version:v1_1_3_18_migrate_order_refund
```

## 同步用户身份证信息 (2018-04-03)

- #seek# 同步用户身份证信息

```shell
cap production deploy:runrake task=data_migrations:version:v1_1_3_18_migrate_shop_user_card
```

## 升级 ruby 2.5.1 (2018-04-03)
- #support# 升级 Ruby 版本到 `2.5.1`
- [gem] gem 'newrelic_rpm' update to version '5.0.0.342'

## 同步店主开店信息 (2018-04-02)

- #seek# 同步订单支付记录
- #seek# 同步用户收货地址

```shell
cap production deploy:runrake task=data_migrations:version:v1_1_3_17_migrate_order_pay
```

## 优化店主行为报表计算逻辑(2018-03-30)

- #enhance# 缓存店主行为数据刷新的的时间戳，解决每次计算店主行为数据都需要统计所有项的问题

```shell
```

## 商品复购率报表(2018-03-27)

- #feature# 新增商品复购率报表

```shell
cap production deploy:runrake task=data_migrations:version:v1_1_3_16_migrate_product_repurchase
```

## 每日店主等级运营报表(2018-03-23)

- #feature# 新增每日店主等级运营报表
- #feature# 新增店主留存率报表

```shell
cap production deploy:runrake task=data_migrations:version:v1_1_3_15_migrate_daily_shop_grade_operational
cap production deploy:runrake task=data_migrations:version:v1_1_3_15_migrate_shop_retention
```

## 店主行为报表增加账户余额(2018-03-22)

- #feature# 店主行为报表增加账户余额, 账户总收入，芝蚂币余额
- #feature# 店主行为报表支持记录流水类型数据(如账户余额),但是不计入累计和汇总报表

```shell
cap production deploy:runrake task=data_migrations:version:v1_1_3_15_migrate_shop_activity_coin_data
```

## 店主行为报表增加芝蚂币(2018-03-20)

- #feature# 店主行为报表增加芝蚂币

```shell
cap production deploy:runrake task=data_migrations:version:v1_1_3_15_migrate_shop_activity_coin_data
```

## 升级 Rails 到 5.2(2018-03-19)

- #support# 升级 Rails 到 5.2.0

```shell
```

## 店主行为报表增加提现金额(2018-03-14)

- #feature# 店主行为报表增加提现金额
- #feature# 每日运营报表增加提现金额

```shell
cap production deploy:runrake task=data_migrations:version:v1_1_3_12_migrate_shop_activity_withdraw_amount
```

## 店主行为报表增加下级激活数(2018-03-14)

- #feature# 店主行为报表增加下级激活数
- #feature# 同步提现记录
- #feature# 同步银行卡信息

```shell
cap production deploy:runrake task=data_migrations:version:v1_1_3_11_migrate_descendant_activation_count
cap production deploy:runrake task=data_migrations:version:v1_1_3_12_init_withdraw_record_trigger
```
## 店主拓扑表增加等级变更时间(2018-03-13)

- #feature# 店主拓扑表增加等级变更时间
- #enhance# 调整店主运营程序缓存时效
- #enhance# 缩短同步芝蚂城数据服务执行间隔到3分钟

```shell
cap production deploy:runrake task=data_migrations:version:v1_1_3_10_migrate_shopkeeper_upgrade_grade_at
```

## 每日运营报表计算成本和券(2018-03-12)

- #feature# 每日运营报表计算芝蚂币

```shell
cap production deploy:runrake task=data_migrations:version:v1_1_3_9_migrate_order_coin
cap production deploy:runrake task=data_migrations:version:v1_1_3_9_migrate_income_record_coin
cap production deploy:runrake task=data_migrations:version:v1_1_3_4_migrate_daily_operational_report
```

## 每日运营报表计算成本和券(2018-03-05)

- #feature# 每日运营报表计算成本和券

```shell
cap production deploy:runrake task=data_migrations:version:v1_1_3_5_init_seek_trigger
cap production deploy:runrake task=data_migrations:version:v1_1_3_4_migrate_daily_operational_report
```

## 每日运营报表(2018-03-02)

- #feature# 新增每日运营报表

```shell
cap production deploy:runrake task=data_migrations:version:v1_1_3_4_migrate_daily_operational_report
```

## 店主行为相关报表添加下级和直接邀请相关统计 (2018-02-26)

- #feature# 店主行为相关报表添加 `children_size`, `descendant_size`, `descendant_order_number`, `descendant_order_amount`, `descendant_commission_income_amount` 字段

```shell
cap production deploy:runrake task=data_migrations:version:v1_1_3_3_migrate_shop_activity_children_stat_field
```

## 店主行为报表相关增加总数据 (2018-02-23)

- #feature# 店主运营程序店铺运营分析报表接口增加店铺总收入分类收入字段
- #feature# 芝蚂助手店主详情接口增加店铺总收入分类收入字段


```shell
cap production deploy:runrake task=data_migrations:version:v1_1_3_2_migrate_shop_income_amount
```

## 店主行为报表相关增加总数据 (2018-02-05)

- #feature# 店主行为报表相关增加总数据
- #feature# 店主平台运营程序累计店主行为报表-增加总数据


```shell
cap production deploy:runrake task=data_migrations:version:v1_1_3_migrate_shop_acitvity_total_stat
```

## 同步店主开店信息 (2018-02-02)

- #seek# 同步店主开店信息
- #feature# 店主平台运营程序拓扑接口增加开店支付金额,账户总收入,账户余额,
  已提现金额,冻结金额,状态,邀请码


```shell
cap production deploy:runrake task=data_migrations:version:v1_1_2_migrate_shopkeeper_info
```

## Dev 报表导出到 Excel (2018-02-02)

- #enhance# 重构导出服务，使用 active_model, 移除手动分页，封装参数到 `params`
- #feature# dev 报表新增店主报表导出服务实现
- #feature# dev 报表店主ECN报表导出服务实现
- #feature# dev 报表店主行为报表导出服务实现
- #feature# dev 报表累计店主行为报表导出服务实现
- #feature# dev 报表城市店主行为报表导出服务实现
- #feature# dev 报表订单销售报表导出服务实现
- #feature# dev 报表订单信息导出服务实现
- #feature# dev 报表店主组织架构树导出服务实现

```shell
```

## 店主平台运营程序 累计店主行为报表 (2018-01-25)

- #feature# 店主平台运营程序 累计店主行为报表

```shell
```

## web 端权限控制 (2018-01-24)

- #feature# web 端权限控制

```shell
cap production deploy:runrake task=data_migrations:version:v1_1_1_init_web_permission
```

## 优化渠道下属店铺查询 (2018-01-18)

- #enhance# 优化渠道下属店铺查询
- #feature# 店主平台运营程序店铺对象相关接口返回店铺头像

```shell
cap production deploy:runrake task=data_migrations:version:v1_0_12_migrate_shop_channel_id
cap production deploy:runrake task=data_migrations:version:v1_0_13_migrate_shop_info
```

## 同步店铺分享日志 (2018-01-15)

- #feature# 同步店铺分享日志
- #feature# 同步店铺浏览日志
 
```shell
cap production deploy:runrake task=data_migrations:version:v1_0_11_init_seek_trigger
```

## 店主ECN报表 (2018-01-12)

- #feature# 店主ECN报表

```shell
```

## 城市店主行为报表 (2018-01-08)

- #feature# 城市店主行为报表

```shell
```

## 店主平台运营程序接口 (2018-01-04)

- #feature# 店主平台运营程序接口
- #enhance# 使用 `jbuilder_cache_multi` 加速缓存读取速度
- #enhance# 大量页面缓存的使用, 减少 `json` 渲染时间
- #support# 升级 Ruby 版本到 `2.5.0`

```shell
cap production deploy:runrake task=db:seed
cap production unicorn:stop && cap production unicorn:start
```

## 渠道的新增店主报表 (2017-12-25)

- 渠道的新增店主报表

```shell
cap production deploy:runrake task=data_migrations:version:v1_0_10_init_report_channel_shop_newer
```

## 芝蚂助手店主订单优化 (2017-12-15)

- 拉取C端用户数据
- [hack] api return data should not allow nil value for `[]`, and `{}`

```shell
cap production deploy:runrake task=data_migrations:version:v1_0_8_init_seek_trigger
```

## 芝蚂助手店主订单优化 (2017-12-11)

- 芝蚂助手列表页新增搜索
- 芝蚂助手列表页新增排序
- 芝蚂助手列表页新增按照渠道筛选
- 芝蚂助手店主列表页查看直接店主

```shell
cap production deploy:runrake task=data_migrations:version:v1_0_7_shopkeeper_income_amount
```

## 增量拉取芝蚂城子订单数据 (2017-12-05)

- 增量拉取芝蚂城子订单数据
- 订单监控详情页接口

```shell
cap production deploy:runrake task=data_migrations:version:v1_0_6_init_seek_trigger
```

## 增量拉取芝蚂城数据 (2017-12-05)

- 重构增量拉取芝蚂城数据逻辑

```shell
cap production deploy:runrake task=data_migrations:version:v1_0_5_init_seek_trigger
```

## 渠道管理员 (2017-11-24)

- 渠道管理员

```shell
cap production deploy:runrake task=data_migrations:version:v1_0_3_channel_user_shop
```

## 芝蚂城渠道运营 APP (2017-11-20)

- 芝蚂城渠道运营 APP (芝蚂助手)上线