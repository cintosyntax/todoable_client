require 'base64'
require 'json'
require 'todoable/errors'
require 'todoable/api_response'

module Todoable
  class Client
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
      return if token_expires_at.nil? || !token_expires_at.is_a?(Time)
      Time.now > token_expires_at
    end

    # -- API Methods --

    def fetch_lists
      res = send_api_request(:get, '/lists')
      Todoable::ApiResponse.new(res).to_hash
    end

    def fetch_list(id)
      res = send_api_request(:get, "/lists/#{id}")
      Todoable::ApiResponse.new(res).to_hash
    end

    def create_list(name)
      body = {
        list: {
          name: name
        }
      }.to_json

      res = send_api_request(:post, '/lists', body: body)
      Todoable::ApiResponse.new(res).to_hash
    end

    def delete_list(id)
      res = send_api_request(:delete, "/lists/#{id}")
      Todoable::ApiResponse.new(res).to_hash
    end

    def create_list_item(list_id, item_name)
      body = {
        item: {
          name: item_name
        }
      }.to_json

      path = "/lists/#{list_id}/items"
      res = send_api_request(:post, path, body: body)
      Todoable::ApiResponse.new(res).to_hash
    end

    def finish_list_item(list_id, item_id)
      path = "/lists/#{list_id}/items/#{item_id}/finish"
      res = send_api_request(:put, path)
      Todoable::ApiResponse.new(res).to_hash
    end

    def delete_list_item(list_id, item_id)
      path = "/lists/#{list_id}/items/#{item_id}"
      res = send_api_request(:delete, path)
      Todoable::ApiResponse.new(res).to_hash
    end

    private

    def send_api_request(method, path, params = {})
      authenticate if token.nil? || token_expired?

      request_params = {
        method: method, path: "/api/#{path}", body: params[:body]
      }.merge(headers: authorization_header)

      res = connection.request(request_params)

      if res.status == 401
        # Token stored is invalid despite token not being expired. Authenciate
        # again and try the request once more.
        authenticate
        res = connection.request(request_params)
      end

      res
    end

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
      self.token = auth_body['token']
      self.token_expires_at = auth_body['expires_at']
    end

    def authorization_header
      return if token.nil?
      { 'Authorization' => "Token token=#{token}" }
    end
  end
end
