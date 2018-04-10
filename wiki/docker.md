## Integrate Docker

### References

- https://store.docker.com/editions/community/docker-ce-desktop-mac
- https://jsfun.info/archive/docker%E5%9C%A8%E5%9B%BD%E5%86%85%E4%BD%BF%E7%94%A8%E7%9A%84%E5%8A%A0%E9%80%9F%E9%85%8D%E7%BD%AE/
- http://mirrors.aliyun.com/docker-toolbox/mac/docker-for-mac/
- https://blog.codeship.com/using-docker-compose-for-ruby-development/
- https://github.com/GoogleCloudPlatform/ruby-docker/tree/master/ruby-base
- http://bradgessler.com/articles/docker-bundler/
- http://equinox.one/blog/2016/04/20/Docker-with-Ruby-on-Rails-in-development-and-production/
- https://blog.codeship.com/get-started-quickly-with-docker-and-sidekiq/

### Setup Docker

In Order to install Docker,Pls refer https://store.docker.com/search?offering=community&type=edition

### Speed up Via Docker mirror

参照 https://www.jianshu.com/p/9fce6e583669 配置镜像 `https://registry.docker-cn.com`

### 构建镜像

```shell
cp -r conf_example/* conf/
docker-compose build
docker-compose run web bundle install

docker-compose run web bundle exec rails db:setup db:seed
docker-compose up

docker-compose exec cron bash -it
```