module DeviceDetectable
  extend ActiveSupport::Concern

  included do
    helper_method :android?, :ios?, :android_or_ios?, :h5_show?, :device
  end

  def android?
    device == "android"
  end

  def ios?
    device == "ios"
  end

  def android_or_ios?
    android? || ios?
  end

  def h5_show?
    device == "h5"
  end

  def device
    auth_params[:device].presence
  end
end
