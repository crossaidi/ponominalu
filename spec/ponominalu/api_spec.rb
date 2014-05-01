require 'spec_helper'

describe Ponominalu::API do

  def create_connection
    
  end

  describe '#call_api_method' do
    subject { Ponominalu.client }
    it 'calls defined api method' do
      # pending
      expect(subject.get_events).to eq('get_events')
      expect(subject.get_venues).to eq('get_venues')
    end
  end
end