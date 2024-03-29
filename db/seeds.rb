# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.where(email: "test@qq.com").first_or_create
user.update(
  password: "11111111", phone: "1234567890",
  role_type: :manager
)
user.api_token

user = User.where(email: "open@qq.com").first_or_create
user.update(
  password: "11111111", phone: "1234567891",
  role_type: :open_manager
)
user.api_token