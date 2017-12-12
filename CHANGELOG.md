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