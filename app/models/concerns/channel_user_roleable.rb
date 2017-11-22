module ChannelUserRoleable
  extend ActiveSupport::Concern

  included do
  end

  def all_own?
    manager?
  end

  def self_own?
    normal_user?
  end

  module ClassMethods
  end
end
