require 'spec_helper'

describe Ponominalu::Configuration do

  class ConfigurationTest
    extend Ponominalu::Configuration
  end

  subject { ConfigurationTest }

  describe '.configure' do
    let(:options) { { session: '321', empty_strict: true, max_retries: 4 } }

    it 'configured by passed hash' do
      subject.configure(options)
      expect(subject.session).to eq('321')
      expect(subject.empty_strict).to be_true
      expect(subject.max_retries).to eq(4)
    end

    it 'yields self' do
      expect(subject).to receive(:option)
      subject.configure { |pn| pn.option }
    end

    it 'returns self' do
      expect(subject.configure).to eq(subject)
    end
  end

  it 'defines log params predicates as aliases' do
    expect { subject.log_requests = false }.to change { subject.log_requests? }
      .from(true).to(false)
    expect { subject.log_responses = true }.to change { subject.log_responses? }
      .from(false).to(true)
  end

  describe '.reset' do
    it 'resets options to default values' do
      subject.reset

      expect(subject.adapter).to eq(:net_http)
      expect(subject.logger).to be_instance_of(::Logger)
      expect(subject.session).to eq('123')
      expect(subject.max_retries).to eq(2)
      expect(subject.empty_strict).to be_false
      expect(subject.raw_json).to be_false
      expect(subject.log_requests).to be_true
      expect(subject.log_responses).to be_false
      expect(subject.wrap_response).to be_false
      expect(subject.http_verb).to eq(:post)
      expect(subject.faraday_options).to eq({})
    end
  end
end