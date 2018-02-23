require 'spec_helper'

describe "something" do
  context "with something false" do
    subject { false }
    it { should_not be}
  end
end
