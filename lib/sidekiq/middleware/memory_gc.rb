class Sidekiq::Middleware::MemoryGc
  def call(*args)
    # ActiveRecord::Base.connection.uncached do
      yield
    # end
    gc_start if call_times % gc_frequency == 0
  end

  def gc_frequency
    ENV["SIDEKIQ_GC_FREQUENCY"].present? ? ENV["SIDEKIQ_GC_FREQUENCY"].to_i : 100
  end

  def call_times
    @@_call_times ||= 0
    @@_call_times += 1
  end

  def rss_usage
    `ps -o rss= -p #{Process.pid}`.chomp.to_i * 1024
  end

  def gc_stats
    GC.stat.slice(:heap_available_slots, :heap_live_slots, :heap_free_slots)
  end

  def gc_start
    GC.start
    gc_stats.each do |key, value|
      puts "Sidekiq GC.#{key}: #{value.to_s(:delimited)}"
    end
    puts "Sidekiq RSS: #{rss_usage.to_s(:human_size, precision: 3)}"
  end
end
