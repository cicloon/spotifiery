# encoding: utf-8

require 'httparty'
require 'active_support'
require 'webmock/rspec'
require 'vcr'
require 'json'

require_relative '../lib/spotifiery'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock  
end
