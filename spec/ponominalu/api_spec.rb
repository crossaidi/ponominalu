require 'spec_helper'

describe Ponominalu::API do
  def create_connection
    @response = '{ \'code\' => 1, \'message\' => \'result\' }'

    @connection = Faraday.new do |builder|
      builder.adapter  :test do |stub|
        stub.post('/api_method') do
          [200, {}, @response]
        end
      end
    end
    subject.stub(:connection).and_return(@connection)
  end

  describe ".call_method" do

    before(:each) do
      create_connection
    end

    it "calls a connection" do
      Ponominalu::Response.stub(:process)
      expect(subject).to receive(:connection)
      subject.call_method('api_method', { some: :params })
    end

    it "returns the response body" do
      @response = @connection.send(Ponominalu.http_verb, 'api_method', {}).body
      Ponominalu::Response.stub(:process).and_return(@response)

      expect(subject.call_method('api_method')).to eq(@response)
    end

    it "gets an HTTP verb from Ponominalu.http_verb" do
      Ponominalu::Response.stub(:process)
      http_verb = double("HTTP verb")
      Ponominalu.http_verb = http_verb

      response = double("Response", body: double)
      expect(@connection).to receive(:send).with(http_verb, 'api_method', {}).and_return(response)
      subject.call_method('api_method')
    end

    after(:each) do
      Ponominalu.reset
    end
  end

  describe '.connection' do
    let(:url) { double('URL') }
    let(:faraday_options) { double('Faraday options') }

    it 'initiliazes new Faraday connection' do
      Ponominalu.stub(:faraday_options).and_return(faraday_options)
      expect(Faraday).to receive(:new).with(url, faraday_options)
      subject.connection(url)
    end
  end
end