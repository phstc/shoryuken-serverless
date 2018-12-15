require 'json'
require 'ostruct'

def to_message(record)
  # sample record
  # "messageId": "...",
  # "receiptHandle": "...",
  # "body": "...",
  # "attributes": {
  #     "ApproximateReceiveCount": "1",
  #     "SentTimestamp": "1544881108683",
  #     "SenderId": "...:pablo",
  #     "ApproximateFirstReceiveTimestamp": "1544881108691"
  # },
  # "messageAttributes": {},
  # "md5OfBody": "...",
  # "eventSource": "aws:sqs",
  # "eventSourceARN": "arn:aws:sqs:us-east-1::...",
  # "awsRegion": "us-east-1"
  #
  # create a Shoryuken compatible message
  # so that this https://github.com/phstc/shoryuken/blob/master/lib/shoryuken/default_worker_registry.rb#L15
  # and this https://github.com/phstc/shoryuken/blob/352b20642b4b8a123b821228231ed5a5c618a9cc/lib/shoryuken/body_parser.rb
  # work
  OpenStruct.new(
    message_attributes: record['messageAttributes'],
    body: record['body'],
    queue: record['eventSourceARN'].split(':').last
  )
end

def handler(event:, context:)
  event['Records'].each do |record|
    puts JSON.generate(to_message(record))
  end

  puts JSON.generate(context.inspect)
end