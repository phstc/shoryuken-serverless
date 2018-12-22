class TestStandardWorker
  include Shoryuken::Worker

  shoryuken_options body_parser: :text, queue: ENV['QUEUE_STANDARD']

  def perform(_sqs_msg, name)
    puts "Hello from Standard Worker, #{name}"
    # say hi to Active Job
    # see app/jobs/test_active_job.rb
    TestActiveJob.perform_later(name: "*#{name}*")
  end
end
