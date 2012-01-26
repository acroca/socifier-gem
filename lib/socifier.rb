require "socifier/version"

module Socifier
  CONFIGURATION_KEYS = [:api_key]
  class << self
    attr_accessor :configuration

    def configure(&block)
      self.configuration ||= Struct.new("Configuration", *CONFIGURATION_KEYS).new
      block.call self.configuration
    end
  end
end
