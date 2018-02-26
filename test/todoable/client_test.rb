# frozen_string_literal: true

require 'test_helper'

module Todoable
  class ClientTest < Minitest::Test
    def setup
      @client = Todoable::Client.new('faux_username', 'faux_password')
      Excon.stubs.clear
      Excon.stub({}, body: 'Fallback', status: 200)
    end

    class AuthenticationTests < ClientTest
      def test_authenticate_with_valid_credentials
        assert_nil @client.token
        assert_nil @client.token_expires_at

        Excon.stub({},
                   status: 200,
                   body: {
                     token: 'I have a token!', expires_at: Time.now + 20
                   }.to_json)
        @client.authenticate

        refute_nil @client.token
        refute_nil @client.token_expires_at
      end

      def test_authenticate_with_invalid_credentials
        assert_raises Todoable::Errors::InvalidCredentials do
          Excon.stub({}, status: 401)
          @client.authenticate
        end
      end

      def test_unexpected_authentication_response
        assert_raises Todoable::Errors::UnexpectedResponse do
          Excon.stub({}, status: 500)
          @client.authenticate
        end
      end

      def test_token_expired?
        @client.token_expires_at = Time.now - 200
        assert_equal(true, @client.token_expired?)

        @client.token_expires_at = Time.now + 200
        assert_equal(false, @client.token_expired?)

        @client.token_expires_at = 'not a time'
        assert_nil @client.token_expired?
      end
    end

    class ApiRequests < ClientTest
      def test_authenticate_on_expired_token
        @client.token_expires_at = Time.now - 200

        assert @client.token_expired?

        authenticate_called = false
        @client.stub :authenticate, -> { authenticate_called = true } do
          @client.send(:send_api_request, :get, '/wibble')
        end

        assert authenticate_called
      end

      def test_authenticate_on_token_undefined
        refute @client.token_expired?
        @client.token = nil

        authenticate_called = false
        @client.stub :authenticate, -> { authenticate_called = true } do
          @client.send(:send_api_request, :get, '/wibble')
        end

        assert authenticate_called
      end

      def test_authenticate_on_unauthorized_response
        Excon.stub({ path: '/i-am-not-allowed-to-see-this' }, status: 401)

        authenticate_called = false
        @client.stub :authenticate, -> { authenticate_called = true } do
          @client.send(:send_api_request, :get, '/i-am-not-allowed-to-see-this')
        end

        assert authenticate_called
      end
    end
  end
end
