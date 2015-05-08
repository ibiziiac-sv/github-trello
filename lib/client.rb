require 'trello'

Trello.configure do |config|
  config.developer_public_key = ENV.fetch('TRELLO_KEY') { 'test_key' }
  config.member_token = ENV.fetch('TRELLO_MEMBER_TOKEN') { 'test_token' }
end

