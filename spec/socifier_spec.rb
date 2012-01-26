require 'spec_helper'

describe Socifier do
  describe ".configure" do
    subject { Socifier.configuration }

    describe "api_key" do
      before { Socifier.configure{|c| c.api_key = "my_api_key" } }
      its(:api_key) { should == "my_api_key" }
    end
  end
end