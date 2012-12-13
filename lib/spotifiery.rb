 # encoding: utf-8

require 'httparty'
require 'active_support'

module Spotifiery
  extend ActiveSupport::Autoload

  autoload :Searchable
  autoload :SearchResult


end
