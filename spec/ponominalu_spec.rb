require 'spec_helper'

describe Ponominalu do
  context 'when short alias is registered' do
    it 'automatically registers the short alias' do
      expect(subject).to eq(Pn)
    end
  end

  context 'when delegating to API module' do
    it 'delegates methods to API.call_method' do
      expect(subject::API).to receive(:call_method)
        .with(:test_method)
      subject.test_method
    end
  end
end
