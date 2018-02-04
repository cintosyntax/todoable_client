require 'base64'
require 'json'

module Todoable
  class Client
    require 'todoable/errors'

    attr_accessor :username, :password, :token, :token_expires_at

    def initialize(username, password)
      @username = username
      @password = password
    end

    def authenticate
      res = connection.post(
        path: '/api/authenticate',
        headers: { 'Authorization' => "Basic #{base64_encoded_credentials}" }
      )

      raise Errors::InvalidCredentials if res.status == 401
      raise Errors::UnexpectedResponse.new(__method__, res) if res.status != 200

      store_auth_data(res)
    end

    def token_expired?
      return if @token_expires_at.nil? || !@token_expires_at.is_a?(Time)
      Time.now > @token_expires_at
    end

    private

    def connection
      @connection ||= Excon.new(
        'http://todoable.teachable.tech/',
        headers: {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json'
        }
      )
    end

    def base64_encoded_credentials
      Base64.encode64("#{username}:#{password}")
    end

    def store_auth_data(auth_response)
      auth_body = JSON.parse(auth_response.body)
      @token = auth_body['token']
      @token_expires_at = auth_body['expires_at']
    end
  end
end
