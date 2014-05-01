require 'spec_helper'

describe Ponominalu do
  context 'when delegating' do
    it 'is Ponominalu::Client instance' do
      expect(subject.client).to be_a(Ponominalu::Client)
    end
  end

  describe '.configure' do
    it 'is configured to default values when options is empty' do
      expect(subject.session).to eq('123')
      expect(subject.adapter).to eq(:net_http)
    end

    it 'is configured by passing hash' do
      subject.configure({
        adapter: :excon,
        session: '333444'
      })
      expect(subject.adapter).to eq(:excon)
      expect(subject.session).to eq('333444')
    end

    it 'is configured by giving block' do
      subject.configure do |config|
        config.adapter = :excon
        config.session = '333444'
      end
      expect(subject.adapter).to eq(:excon)
      expect(subject.session).to eq('333444')
    end
  end
end
