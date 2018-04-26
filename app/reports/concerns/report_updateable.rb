module ReportUpdateable
  extend ActiveSupport::Concern

  included do
  end

  def perform(skip_save: false)
    begin
      process

      write if not skip_save
    rescue => e
      logger.warn "update report failure #{e}, record: #{record.try(:attributes)}"
      log_error(e)
    end
  end


  def write
    begin
      record.save!
    rescue => e
      logger.warn "update report failure #{e}, record: #{record.try(:attributes)}"
      log_error(e)
    end
  end
  module ClassMethods
  end
end