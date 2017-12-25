## 芝蚂城 BI Api 架构

本文档目的是描述有关组织和架构芝蚂城 BI Api 的一些约定和规范。

```shell
app/controllers/
├── api
│   ├── channel # 渠道移动端 api
│   │   ├── auth_controller.rb
│   │   ├── base_controller.rb
│   │   └── ping_controller.rb
│   ├── mobile # BI 移动端 api
│   │   ├── auth_controller.rb
│   │   ├── base_controller.rb
│   │   └── ping_controller.rb
│   │── dev # 开发者接口
│   └── web # web pc api
├── application_controller.rb
└── concerns
    └── api
        ├── channel
        │   ├── authenticateable.rb
        │   └── rescueable.rb
        ├── device_detectable.rb
        └── mobile
            ├── authenticateable.rb
            └── rescueable.rb
```