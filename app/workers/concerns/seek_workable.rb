module SeekWorkable
  extend ActiveSupport::Concern

  included do
    include SesameMall::SeekLoggerable
  end

  def extract_seek_options(options: {})
    _duration = options["duration"]

    {
      duration: _duration.present? ? _duration.minutes : 15.minutes
    }
  end
  module ClassMethods
  end
end