# Be sure to restart your server when you modify this file.

Rails.application.config.generators do |g|
  g.template_engine nil #to skip views
  g.test_framework  nil #to skip test framework
  g.assets  false
  g.helper false
  g.stylesheets false
end