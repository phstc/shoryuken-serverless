# Load Rails
puts 'Loading Rails...'
require_relative 'config/environment'

def to_sqs_msg(record)
  Aws::SQS::Types::Message.new(
    body: record['body'],
    md5_of_body: record['md5OfBody'],
    message_attributes: record['messageAttributes'],
    message_id: record['messageId'],
    receipt_handle: record['receiptHandle']
  )
end

def handler(event:, context:)
  event['Records'].each do |record|
    queue = record['eventSourceARN'].split(':').last
    Shoryuken::Processor.process(queue, to_sqs_msg(record))
  end
end
