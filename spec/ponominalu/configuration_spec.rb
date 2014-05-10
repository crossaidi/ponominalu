require 'spec_helper'

describe Ponominalu::Configuration do
  subject { Ponominalu }
  describe '.configure' do
    let(:options) { { session: '321', empty_strict: true, max_retries: 4 } }
    it 'configured by passed hash' do
      subject.configure(options)
      expect(subject.session).to eq('321')
      expect(subject.empty_strict).to be_true
      expect(subject.max_retries).to eq(4)
    end
  end

  it 'defines log params predicates as aliases' do
    expect { subject.log_requests = false }.to change { subject.log_requests? }
      .from(true).to(false)
    expect { subject.log_responses = true }.to change { subject.log_responses? }
      .from(false).to(true)
  end
end