require 'spec_helper'

describe Todoable::Client do
  let(:client) { described_class.new(username, password)}
  let(:username) { 'Buck' }
  let(:password) { 'Mason' }

  describe "initialize" do
    context "when given no username or password" do
      it "raises an argument error" do
        expect { described_class.new }.to raise_error(ArgumentError)
      end
    end

    context "when given a username and password" do
      subject { client }
      it { should be_a(Todoable::Client) }
    end
  end
end
