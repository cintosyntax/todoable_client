require 'test_helper'

module Todoable
  class ClientTest < Minitest::Test
    class Authentication < Todoable::ClientTest
      def setup
        @client = Todoable::Client.new('faux_username', 'faux_password')
        Excon.stubs.clear
      end

      def test_successful_authenticate
        assert_nil @client.token
        assert_nil @client.token_expires_at

        Excon.stub({},
                   status: 200,
                   body: {
                     token: 'I have a token!', expires_at: Time.now + 20
                   }.to_json)
        @meme = Minitest::Mock.new
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
  end
end
