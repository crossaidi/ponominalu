require 'spec_helper'

describe Ponominalu::Helpers do

  describe '.flatten' do
    let(:args) { { str_arg: 'string', array_arg: ['str1', 'str2'] } }

    it 'leaves flat arguments untouched and flats a collection' do
      expect(subject.flatten(args))
        .to eq({ str_arg: 'string', array_arg: 'str1,str2' })
    end
  end

  describe '.parse_params' do
    pending
  end
end