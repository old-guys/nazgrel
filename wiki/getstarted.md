### repo

```shell
git clone git@gitlab.ishanggang.com:bi/nazgrel.git
```

### Built Nazgrel

```shell
rails new nazgrel --database=mysql --skip-puma --skip-action-cable --skip-turbolinks --skip-bundle
```

### extra package for system

```shell
sudo apt-get update
sudo apt-get install -y python-software-properties python g++ make
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install nodejs
```

```shell
sudo apt-get install libxml2-dev libxslt-dev
sudo apt-get install redis-server
brew install yarn
```

### set rvm

```shell
cd nazgrel
# sudo -i
# rvm use 2.5.0@nazgrel --create
# https://rvm.io/workflow/projects/
rvm --create --ruby-version use 2.5.1@nazgrel
```

### choose and add gems

* rails
* jquery-rails
* coffee-rails
* capistrano, rvm-capistrano
* thin

### deploy

qa env

database: nazgrel_qa

### references

* [rails webpacker react](https://x-team.com/blog/get-in-full-stack-shape-with-rails-5-1-webpacker-and-reactjs/)
* [yarn install](https://yarnpkg.com/lang/en/docs/install/#linux-tab)