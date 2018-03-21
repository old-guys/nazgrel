Welcome To Nazgrel!

Nazgrel is based on Rails + MySQL + Redis,

### 各环境部署主机及目录说明

  ssh账号和端口： ishanggang_dev / 40022

  登录网站的测试账号： test@qq.com / 11111111

| 环境名称 | ssh主机地址、部署目录 | 应用域名 |
| --------- | ------- | ------- |
| 测试环境      |     qa.bi.ishanggang.com:/ishanggang/apps/nazgrel_qa/current   |   http://qa.bi.ishanggang.com |
| 生产环境      |     bi.ishanggang.com:/ishanggang/apps/ishanggang_production/current   |   http://bi.ishanggang.com |

安装依赖

        Mac OS X
                brew install git mysql redis cmake

        Ubuntu
                sudo apt-get install libmysqlclient-dev redis-server

        Cent OS
                sudo yum install mysql-devel redis-server git

设置数据库

Mac OS [Lost connection to MySQL server](wiki/mac_mysql.md) 解决办法

        scp -P 40022 ishanggang_dev@test.e.ishanggang.com:~/shared/*_testing.sql.gz .
        gunzip *_testing.sql.gz
        mysql -uroot -p -e "CREATE DATABASE nazgrel_development DEFAULT CHARSET utf8"
        mysql -uroot -p nazgrel_development < nazgrel_testing.sql
        mysql -uroot -p ishanggang_cms_development < ishanggang_cms_testing.sql

克隆代码、拷贝配置文件

      git clone ssh://gitlab@gitlab.ishanggang.com:40022/ishanggang_server/nazgrel.git
      cd nazgrel

      cp config/database.yml.example config/database.yml
      cp config/services.yml.example config/services.yml

配置文件说明


      database.yml    # 数据库配置文件
      services.yml    # 服务配置文件
      sidekiq.yml     # sidekiq 队列配置文件
      newrelic.yml    # newrelic 配置文件
      nginx.conf      # nginx 配置文件
      logrotate.conf  # 日志切割配置文件


通过 [RVM](https://rvm.io/) 安装 Ruby 和 Gems

      gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
      \curl -sSL https://get.rvm.io | bash -s stable
      echo "ruby_url=https://cache.ruby-china.org/pub/ruby" > ~/.rvm/user/db
      rvm install 2.5.0
      rvm use 2.5.0 --default
      rvm gemset create nazgrel
      rvm gemset use nazgrel
      echo 'gem: "--no-doc --no-ri"' >> ~/.gemrc
      gem source -a https://gems.ruby-china.org
      gem source -r https://rubygems.org
      gem install bundler && bundle && bundle exec rake db:migrate

启动项目，在浏览器中访问： http://localhost:3000/users/sign_in (测试账号 test@qq.com / 11111111)

      bundle exec rails s -p 3000 -b 0.0.0.0

### Development

在开发环境的时候可以启用一些开关，来方便开发

```yaml
  # 追踪 sql 调用堆栈
  active_record_query_trace: true
  # 记录 active_record 日志到独立文件 `log/active_record.log`
  log_active_record: false
  # 记录 active_record 查询超过`1000 ms`到独立文件 `log/active_record-slow.log`
  log_active_record_slow: 1000
  # 开启开发环境缓存
  touch tmp/caching-dev.txt
```

[code review](https://medium.com/nimbl3/code-reviews-a-tale-of-two-developers-ab1b2a887394) within locale environment

```shell
pronto run
```

## ishanggang server stack

目前 所有的服务器 端口主要分两块
  web 应用程序类
  外部服务类

应用程序类

    nazgrel
      pc web end
      schedule job config/schedule.rb
      sidekiq

外部服务类

      rvm
      nodejs
      mysql-devel
      god
      nginx
      redis

    monitor
      god
        /usr/bin/env ruby /home/ishanggang_dev/script/ishanggang_god_monitor.rb # wiki/god_monitor.md
      newrelic
    deployment
      capistrano

### web 应用程序类
>> 按照部署 每台服务器上面所拥有 应用程序 stage 套数 来 分割 <br />
>> 目前一台服务器最多两套 <br />
>> 目前 web 都通过 nginx 代理公网访问 可以考虑封闭公网访问

    ======================= assign processer port ============================
    # normal port conventions
    # qa
    nazgrel unicorn 7110
    node_faye 7131 7132

    # production
    nazgrel unicorn 7210
    node_faye 7231 7232

    # and more

### 外部服务类

>> 目前外部服务理论上都处于内网连接状态 <br />
>> 并且按照 stage 体系分割

主要是
  mysql (for test + staging) 3306
  redis 6379

### 文件或者目录命名约定

```shell
====================== convention for name file ================================
  upstream
    nazgrel_staging_unicorn
    APPLICATION_STAGE_WEBAPPLICATION
  socket
    unix:/tmp/unicorn.nazgrel_staging.sock
    unix:/tmp/WEBAPPLICATION.APPLICATION_STAGE.sock
  nginx log files
    /var/log/nginx/nazgrel_staging_access.log
    /var/log/nginx/APPLICATION_STAGE_USE.log
  nginx conf files
    /etc/nginx/conf.d/nazgrel_production.conf
    /etc/nginx/conf.d/APPLICATION_STAGE.conf
  app deploy url
    /ishanggang/apps/nazgrel_development/current
    /var/log/nginx/APPLICATION_STAGE/current
```


## Document

- [wiki](wiki/)
- [wiki/project_mau](wiki/project_mau.md)
- [开发者接口](wiki/api_dev.md)