class Sidekiq::Middleware::RequestStore
  def call(*args)
    RequestStore.begin!
    yield
  ensure
    RequestStore.end!
    RequestStore.clear!
  end
end
