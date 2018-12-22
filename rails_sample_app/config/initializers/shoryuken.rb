module Shoryuken
  class Processor
    def process
      unless worker
        logger.error { "No worker found for #{queue}" }
        return false
      end

      Shoryuken::Logging.with_context("#{worker_name(worker.class, sqs_msg, body)}/#{queue}/#{sqs_msg.message_id}") do
        worker.class.server_middleware.invoke(worker, queue, sqs_msg, body) do
          worker.perform(sqs_msg, body)
        end
      end

      true
    rescue Exception => ex
      logger.error { "Processor failed: #{ex.message}" }
      logger.error { ex.backtrace.join("\n") } unless ex.backtrace.nil?

      raise
    end
  end
end