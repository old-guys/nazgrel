module UserPermissionable
  extend ActiveSupport::Concern

  included do
  end

  def permited_permissions
    _permissions = manager? ? Permission.all : permissions
  end

  def cached_permited_permissions
    Rails.cache.fetch("permit:#{role_type}#{permited_permissions.cache_key}") do
      permited_permissions.pluck_h(:name, :subject, :uid)
    end.map{|h| OpenStruct.new h }
  end

  module ClassMethods
  end
end