require "socifier/version"
require "rest-client"

module Socifier
  class NoApiKeySpecified < Exception; end
  class InvalidParams < Exception; end

  CONFIGURATION_KEYS = [:api_key]
  SOCIFIER_PATH = "http://www.socifier.com"

  class << self
    attr_accessor :configuration

    def configure(&block)
      self.configuration ||= Struct.new("Configuration", *CONFIGURATION_KEYS).new
      block.call self.configuration
    end

    def new_socification(params)
      raise NoApiKeySpecified if self.configuration.api_key.nil?
      raise InvalidParams if params[:id].empty? || params[:title].empty?

      query = {
        auth_token: self.configuration.api_key,
        title: params[:title],
        id: params[:id],
        is_recurrent: (params[:is_recurrent] ? "1" : "0")
      }
      url = "#{Socifier::SOCIFIER_PATH}/api/v1/socifications"
      response_code = RestClient.post(url, query) do |response, request, result|
        response.code
      end
      response_code == 201
    end
  end
end
