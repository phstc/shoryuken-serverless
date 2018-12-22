# Load Rails
puts 'Loading Rails...'
require_relative 'config/environment'

class Shoryuken::LambdaMessageParser
  attr_reader :sqs_msg, :queue, :record

  def initialize(record)
    @record = record
    @sqs_msg = to_sqs_msg
    @queue = record['eventSourceARN'].split(':').last
  end

  private

  def to_sqs_msg
    Aws::SQS::Types::Message.new(
      body: record['body'],
      md5_of_body: record['md5OfBody'],
      message_attributes: to_message_attributes,
      message_id: record['messageId'],
      receipt_handle: record['receiptHandle']
    )
  end

  def to_message_attributes
    record['messageAttributes'].each_with_object({}) do |(key, value), acc|
      acc[key] = {
        string_value: value['stringValue'],
        binary_value: value['binaryValue'],
        string_list_values: ['stringListValues'],
        binary_list_values: value['binaryListValues'],
        data_type: value['dataType']
      }
    end
  end
end

Shoryuken.configure_server do |config|
  config.server_middleware do |chain|
    # When your function successfully processes a batch, Lambda deletes its messages from the queue.
    # https://docs.aws.amazon.com/lambda/latest/dg/with-sqs.html
    chain.remove Shoryuken::Middleware::Server::AutoDelete
  end
end

def handler(event:, context:)
  event['Records'].each do |record|
    parser = Shoryuken::LambdaMessageParser.new(record)
    unless Shoryuken::Processor.process(parser.queue, parser.sqs_msg)
      raise "Could not process #{parser.sqs_msg.message_id}"
    end
  end
end
