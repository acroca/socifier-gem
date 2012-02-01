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
      require_api_key!
      raise InvalidParams if params[:id].empty? || params[:title].empty?

      query = {
        title: params[:title],
        id: params[:id],
        is_recurrent: (params[:is_recurrent] ? "1" : "0")
      }
      url = "#{Socifier::SOCIFIER_PATH}/api/v1/socifications"
      send_request(:post, url, query) == 201
    end

    def add_subscribers(params)
      require_api_key!
      raise InvalidParams if params[:emails].empty? || params[:id].to_s.empty?

      url = "#{Socifier::SOCIFIER_PATH}/api/v1/socifications/#{params[:id]}/subscribe_others"
      query = {emails: params[:emails]}
      send_request(:put, url, query) == 201
    end

    def send_mail(params)
      require_api_key!
      raise InvalidParams if params[:id].to_s.empty?

      url = "#{Socifier::SOCIFIER_PATH}/api/v1/socifications/#{params[:id]}/send_mail"
      send_request(:put, url, {}) == 202
    end

    def close(params)
      require_api_key!
      raise InvalidParams if params[:id].to_s.empty?

      url = "#{Socifier::SOCIFIER_PATH}/api/v1/socifications/#{params[:id]}/close"
      send_request(:put, url, {}) == 202
    end

    private

    def send_request(method, url, params)
      params[:auth_token] = self.configuration.api_key
      RestClient.send(method, url, params) do |response, request, result|
        response.code
      end
    end

    def require_api_key!
      raise NoApiKeySpecified if self.configuration.api_key.nil?
    end
  end
end
