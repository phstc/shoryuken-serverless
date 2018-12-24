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

def worker_exists?(queue, sqs_msg)
  !Shoryuken.worker_registry.fetch_worker(queue, sqs_msg).nil?
end

def handler(event:, context:)
  event['Records'].each do |record|
    parser = Shoryuken::LambdaMessageParser.new(record)
    # Shoryuken::Processor does not raise errors if a worker is not found
    # when a worker is not found, the message can't be processed
    # and we want to make sure to raise an error, otherwise the message will be auto deleted
    raise "No worker found for #{parser.queue}" unless worker_exists?(parser.queue, parser.sqs_msg)
    Shoryuken::Processor.process(parser.queue, parser.sqs_msg)
  end
end
