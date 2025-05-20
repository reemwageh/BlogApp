# config/initializers/sidekiq.rb

# Only create scheduled jobs when the app boots normally
Rails.application.config.after_initialize do
  if defined?(Sidekiq)
    Sidekiq.configure_server do |config|
      config.on(:startup) do
        Sidekiq::Cron::Job.create(name: "Delete Old Posts", cron: "0 * * * *", class: "DeleteOldPostsJob")
      end
    end
  end
end