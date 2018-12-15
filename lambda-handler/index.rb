require 'json'

def handler(event:, context:)
  result = { event: JSON.generate(event), context: JSON.generate(context.inspect) }
  puts JSON.generate(event)
  puts JSON.generate(context.inspect)
  result
end
