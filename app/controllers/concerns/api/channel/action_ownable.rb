module Api::Channel::ActionOwnable
  extend ActiveSupport::Concern

  included do
  end

  def own_record_by_channel_user(klass: )
    options = {}

    if params[:channel_id].present?
      if params[:channel_id].match(/^\d+/).present?
        options.merge!(
          channel: Channel.find_by(id: params[:channel_id])
        )
      elsif params[:channel_id] == "channel_only"
        options.merge!(
          channel_only: true
        )
      end
    end
    relation = current_channel_user.all_own_for(klass, options)

    relation
  end

  private
end