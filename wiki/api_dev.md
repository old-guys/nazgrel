## 芝蚂城 BI 开发者接口

本文档目的是描述有关组织和架构芝蚂城 BI 开发者接口。

```shell
app/controllers/
├── api
│   │── dev # 开发者接口
├── application_controller.rb
```

## 拉取数据

- 同步店主

支持参数 `:user_id`, `:user_phone`, `:shop_id`
同步匹配的店主的店铺和店主数据

```shell
curl "http://localhost:3000/api/dev/seeks/sync_shop?shopkeeper[shop_id]=2"
```

- 同步渠道

支持参数 `:user_id`, `:user_phone`, `:shop_id`
同步匹配的店主的渠道的下面的店主和店铺的数据

```shell
curl "http://localhost:3000/api/dev/seeks/sync_channel?shopkeeper[shop_id]=2"
```

- 手动同步

参数

- `job_klass` 支持单个和多个 worker 名
- `duration` 拉取数据的时间区间

```shell
curl  "http://localhost:3000/api/dev/seeks/sync?job_klass=ShopWechatUserSeekWorker&duration=60"
```