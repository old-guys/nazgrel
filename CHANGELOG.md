## 增量拉取芝麻城子订单数据 (2017-12-05)

- 增量拉取芝麻城子订单数据
- 订单监控详情页接口

```shell
cap production deploy:runrake task=data_migrations:version:v1_0_6_init_seek_trigger
```

## 增量拉取芝麻城数据 (2017-12-05)

- 重构增量拉取芝麻城数据逻辑

```shell
cap production deploy:runrake task=data_migrations:version:v1_0_5_init_seek_trigger
```

## 渠道管理员 (2017-11-24)

- 渠道管理员

```shell
cap production deploy:runrake task=data_migrations:version:v1_0_3_channel_user_shop
```

## 芝麻城渠道运营 APP (2017-11-20)

- 芝麻城渠道运营 APP (芝麻助手)上线
