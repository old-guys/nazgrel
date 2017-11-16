# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.where(email: "test@qq.com").first_or_create
user.update(password: "11111111", phone: "1234567890")
user.api_key


channel = Channel.where(name: "测试总代").first_or_create
channel_user = ChannelUser.where(email: "test@qq.com").first_or_create
channel_user.update(password: "11111111", phone: "1234567890", channel: channel)
channel_user.api_key
