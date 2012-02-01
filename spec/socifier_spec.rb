require 'spec_helper'

describe Socifier do
  let(:api_key) { "my_api_key" }
  let(:response_code) { 200 }
  before do
    Socifier.configure{|c| c.api_key = api_key }
    RestClient.stub(:post).and_return(response_code)
    RestClient.stub(:put).and_return(response_code)
  end

  describe ".configure" do
    subject { Socifier.configuration }

    describe "api_key" do
      its(:api_key) { should == "my_api_key" }
    end
  end

  describe ".new_socification" do
    it "calls the API endpoint" do
      RestClient.should_receive(:post).with("#{Socifier::SOCIFIER_PATH}/api/v1/socifications", {
        auth_token: "my_api_key",
        title: "Test socification",
        id: "test",
        is_recurrent: "1"})
      Socifier.new_socification id: "test", title: "Test socification", is_recurrent: true
    end

    context "without API key" do
      let(:api_key) { nil }
      it "raises an exception" do
        expect {
          Socifier.new_socification id: "test", title: "Test socification", is_recurrent: true
        }.to raise_exception(Socifier::NoApiKeySpecified)
      end
    end

    context "invalid params" do
      it "requires title" do
        expect {
          Socifier.new_socification id: "test", title: "", is_recurrent: true
        }.to raise_exception(Socifier::InvalidParams)
      end
      it "requires id" do
        expect {
          Socifier.new_socification id: "", title: "Test socification", is_recurrent: true
        }.to raise_exception(Socifier::InvalidParams)
      end
    end

    describe "response" do
      let(:response_code) { 201 }
      subject { Socifier.new_socification(id: "test", title: "Test socification", is_recurrent: true) }
      it { should be_true }

      context "failed request" do
        let(:response_code) { 403 }
        it { should be_false }
      end
    end
  end

  describe ".add_subscribers" do
    let(:emails) { ["user1@socifier.com", "user2@socifier.com"] }
    let(:socification_id) { "test" }

    def perform_action
      Socifier.add_subscribers id: socification_id, emails: emails
    end
    it "calls the API endpoint" do
      RestClient.should_receive(:post).with("#{Socifier::SOCIFIER_PATH}/api/v1/socifications/test/subscribe_others", {
        emails: ["user1@socifier.com", "user2@socifier.com"]})
      perform_action
    end

    context "without API key" do
      let(:api_key) { nil }
      it "raises an exception" do
        expect { perform_action }.to raise_exception(Socifier::NoApiKeySpecified)
      end
    end

    context "without emails" do
      let(:emails) { [] }
      it "raises an exception" do
        expect { perform_action }.to raise_exception(Socifier::InvalidParams)
      end
    end

    context "without id" do
      let(:socification_id) { nil }
      it "raises an exception" do
        expect { perform_action }.to raise_exception(Socifier::InvalidParams)
      end
    end

    describe "response" do
      let(:response_code) { 201 }
      subject { perform_action }

      it { should be_true }

      context "failed request" do
        let(:response_code) { 404 }
        it { should be_false }
      end
    end
  end
end