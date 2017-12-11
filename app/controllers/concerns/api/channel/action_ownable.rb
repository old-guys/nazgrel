module Api::Channel::ActionOwnable
  extend ActiveSupport::Concern

  included do
  end

  def own_record_by_channel_user(klass: )
    if params[:channel_id].present?
      @selected_channel = Channel.find_by(id: params[:channel_id])
    end
    relation = current_channel_user.all_own_for(klass, channel: @selected_channel)

    relation
  end

  private
end