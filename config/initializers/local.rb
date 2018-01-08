# Be sure to restart your server when you modify this file.

Rails.application.configure do
  config.i18n.load_path += Dir[File.join(Rails.root, 'config', 'locales', '**', '*.{rb,yml}')]
  config.i18n.available_locales = [:'zh-CN', :zh, :en]
  config.i18n.default_locale = :'zh-CN'
end