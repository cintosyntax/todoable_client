require 'spec_helper'

describe Todoable::Client do
  let(:client) { described_class.new(username, password) }
  let(:username) { 'Buck' }
  let(:password) { 'Mason' }

  describe 'initialize' do
    context 'when given no username or password' do
      it 'raises an argument error' do
        expect { described_class.new }.to raise_error(ArgumentError)
      end
    end

    context 'when given a username and password' do
      subject { client }
      it { should be_a(Todoable::Client) }
    end
  end

  describe 'authenticate' do
    subject { -> { client.authenticate } }

    context 'when the client has invalid credentials' do
      before { Excon.stub({}, status: 401) }

      it 'should raise InvalidCredentials error' do
        expect { subject.call }.to raise_error(Todoable::Errors::InvalidCredentials)
      end
    end

    context 'when the client has valid credentials' do
      before { Excon.stub({}, status: 200, body: { token: token, expires_at: expires_at }.to_json) }
      before { subject.call }
      let(:token) { 'a-valid-token' }
      let(:expires_at) { Time.now + (20 * 60) }

      it 'should set the token and token_expires_at' do
        client.token.equal?(token)
        client.token_expires_at.equal?(expires_at)
      end
    end
  end
end
