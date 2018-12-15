class TestActiveJobJob < ActiveJob::Base
  queue_as ENV['QUEUE_NAME']

  def perform(name)
    puts "Hello from Active Job, #{name}"
  end
end