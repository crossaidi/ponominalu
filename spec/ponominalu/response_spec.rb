require 'spec_helper'

describe Ponominalu::Response do
  let(:block) { proc(&:method) }
  let(:data_enum) { double('Enumerable data', each: block ) }
  let(:response_full_enum) { double('Full response', code: 1, message: data_enum) }

  before { Ponominalu.reset }

  describe '.process' do
    it 'returns a string if the raw_json option is true' do
      Ponominalu.raw_json = true
      expect(Oj).to receive(:dump).with(data_enum)
      subject.process(response_full_enum, nil)
    end

    context 'when block given' do
      let(:data_non_enum) { double('Non-enumerable data') }
      let(:response_full_non_enum) { double('Full response', code: 1, message: data_non_enum) }

      it 'receives :map with a block if it is collection' do
        subject.stub(:get_result).and_return(data_enum)
        expect(data_enum).to receive(:map)
        subject.process(response_full_enum, block)
      end

      it 'is yielded if result is non-enumerable' do
        subject.stub(:get_result).and_return(data_non_enum)
        expect(block).to receive(:call).with(data_non_enum)
        subject.process(response_full_non_enum, block)
      end
    end
  end

  describe '.get_result' do
    let(:response_empty) { double('Empty response', code: 0, message: 'empty') }

    it 'returns an empty array if a result is not found' do
      expect(subject.send(:get_result, response_empty)).to eq([])
    end

    it 'does not return an empty array if empty_strict is true' do
      Ponominalu.empty_strict = true
      expect(subject.send(:get_result, response_empty)).not_to eq([])
    end

    it 'returns a result if it is not empty' do
      expect(subject.send(:get_result, response_full_enum))
        .to eq(response_full_enum.message)
    end

    it 'returns a result in a wrapper if the wrap_response option is true' do
      Ponominalu.wrap_response = true
      expect(subject.send(:get_result, response_full_enum))
        .to eq(response_full_enum)
    end
  end
end