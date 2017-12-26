module SesameMall::SeekHookable
  extend ActiveSupport::Concern

  included do
    cattr_accessor :before_process_hooks, :after_process_hooks
  end

  private
  module ClassMethods
    def before_process(method_name)
      self.before_process_hooks ||= []

      before_process_hooks << method_name
    end

    def after_process(method_name)
      self.after_process_hooks ||= []

      after_process_hooks << method_name
    end

    private
  end
end