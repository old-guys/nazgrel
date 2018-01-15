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