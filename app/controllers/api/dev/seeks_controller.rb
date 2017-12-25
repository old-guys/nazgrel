class Api::Dev::SeeksController < Api::Dev::BaseController
  skip_before_action :authenticate!, raise: false

  def index
    render json: seek_jobs.as_json
  end

  def sync
    _klasses = Array.wrap(params[:job_klass])
    _jobs = seek_jobs.select{|job|
      job.klass.in?(_klasses)
    }
    if params[:duration]
      duration = params[:duration].to_i
    end

    _jobs.each {|job|
      duration ||= job.args[0]["duration"]
      job.klass.safe_constantize.perform_async(
        duration: duration
      )
    }

  end

  def sync_shop
    _shopkeepers = SesameMall::Source::Shopkeeper.where(
      sync_shopkeeper_params
    )
    _shops = SesameMall::Source::Shop.where(
      id: _shopkeepers.select(:shop_id)
    )

    _shop_seek = SesameMall::ShopSeek.new
    _shop_seek.do_partial_sync(relation: _shops)
  end

  def sync_channel
    _shopkeeper = SesameMall::Source::Shopkeeper.find_by(
      sync_shopkeeper_params
    )
    _channel = ::Channel.find_by(shopkeeper_user_id: _shopkeeper.try(:user_id))

    _shops = SesameMall::Source::Shop.where(
      id: _channel.try(:shops).pluck(:id)
    )

    _shop_seek = SesameMall::ShopSeek.new
    _shop_seek.do_partial_sync(relation: _shops)
  end

  private
  def sync_shopkeeper_params
    params.require(:shopkeeper).permit(
      :user_id, :user_phone, :shop_id
    )
  end

  def seek_jobs
    Sidekiq::Cron::Job.all.select{|job|
      job.queue_name_with_prefix == 'seek'
    }
  end
end