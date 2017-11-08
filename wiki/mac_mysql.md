`sudo launchctl limit maxfiles unlimited`

创建配置文件

`touch ~/.my.cnf`

相关配置

```bash
[mysqld]
max_allowed_packet=256M
table_open_cache=250
max_connections=100
```

重启服务

`brew services restart mysql`

### trubleshooting

* `Lost connection to MySQL server at 'reading initial communication packet, system error: 102`
* `sudo fs_usage|grep 'my.cnf'` 获取配置文件读取路径
* `ps auxww|grep mysqld` 获取日志文件路径
* `tail -n 100 -f /usr/local/var/mysql/xxx.err | grep FD_SETSIZE` 捕获错误

### 参考资料

* [MySQL 5.7.10 issues with Ruby on OSX 10.11.3](https://stackoverflow.com/questions/35347378/mysql-5-7-10-issues-with-ruby-on-osx-10-11-3)
