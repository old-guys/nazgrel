module UserPermissionable
  extend ActiveSupport::Concern

  included do
  end

  def permited_permissions
    _permissions = manager? ? Permission.all : permissions
    Rails.cache.fetch("permit:#{role_type}#{_permissions.cache_key}") do
      _permissions.pluck_h(:name, :subject, :uid)
    end.map{|h| OpenStruct.new h }
  end

  module ClassMethods
  end
end