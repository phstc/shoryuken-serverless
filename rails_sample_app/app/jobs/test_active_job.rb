class TestActiveJob < ActiveJob::Base
  queue_as ENV['QUEUE_ACTIVEJOB']

  def perform(obj)
    puts "Hello from Active Job, #{obj[:name]}"
  end
end