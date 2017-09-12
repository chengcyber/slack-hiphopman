$:.unshift File.dirname(__FILE__)
require 'freestyle'

Thread.abort_on_exception = true

Thread.new do
  @client.start!
end
