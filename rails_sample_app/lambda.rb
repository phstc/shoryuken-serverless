# Load Rails
puts "Loading Rails..."
require_relative 'config/environment'

def to_sqs_msg(record)
  OpenStruct.new(
    message_attributes: record['messageAttributes'],
    body: record['body'],
    queue: record['eventSourceARN'].split(':').last
  )
end

def handler(event:, context:)
  event['Records'].each.with_index do |record|
    sqs_msg = to_sqs_msg(record)
    Shoryuken::Processor.process(sqs_msg.queue, sqs_msg)
  end
end