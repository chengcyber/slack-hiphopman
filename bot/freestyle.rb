require 'slack-ruby-client'

require 'nokogiri'
require 'open-uri'

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
  config.logger = Logger.new(STDOUT)
  config.logger.level = Logger::INFO
  fail 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
end

client = Slack::RealTime::Client.new

client.on :hello do
  puts client.self.id
  puts "Successfully connected, welcome '#{client.self.name}' to the '#{client.team.name}' team at https://#{client.team.domain}.slack.com."
end

client.on :message do |data|

  # client.typing channel: data.channel

  case data.text
  # when 'bot hi' then
  #   client.message channel: data.channel, text: "Hi <@#{data.user}>!"
  # when 'hippopman' then
  #   client.message channel: data.channel, text: "Hi <@#{data.user}>!"
  # when "<@#{client.self.id}>" then
  #   client.message channel: data.channel, text: "Hi <@#{data.user}>!"
  # when /^bot/ then
  #   client.message channel: data.channel, text: "Sorry <@#{data.user}>, what?"
  when /^<@#{client.self.id}>\s*(.*)/ then
    keyword = data.text.match(/^<@#{client.self.id}\s*(.*)/).captures[0] || ''
    puts "keyword: #{keyword}"

    targetUrl = "http://m.niucodata.com/freestyle/freestyle.php?key=#{CGI::escape(keyword)}"
    doc = Nokogiri::HTML(open(targetUrl))

    content = doc.css('div.mdui-container').text
    startIndex = content.index("\n", 3)
    endIndex = content.index('欣赏')
    freestyleText = content[startIndex...endIndex]
    freestyle = freestyleText.gsub("\n", '')

    puts freestyle

    client.message channel: data.channel, text: "#{freestyle}"
  end
end

# client.on :close do |_data|
#   puts 'Connection closing, exiting.'
# end
#
# client.on :closed do |_data|
#   puts 'Connection has been disconnected.'
# end

# client.start!

@client = client

