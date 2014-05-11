require 'spec_helper'

describe Ponominalu::Error do
  let(:error_data) do
    Hashie::Mash.new(
      {
        code: -200,
        message: 'Test error',
        method_name: 'The method name',
        session: '123'
      }
    )
  end

  describe '#message' do
    let(:error) { Ponominalu::Error.new(error_data) }

    it 'includes params message when params are passed' do
      error_data.params = Hashie::Mash.new({alias: 'alias'})

      message = "Ponominalu returned an error -200: 'Test error'"\
              " after calling method 'The method name'"
      message << " with parameters #{error_data.params.inspect}."
      message << " App session is '123'."

      expect(error.message).to eq(message)
    end

    it 'does not includes params message when params are not passed' do
      error_data.params = []

      message = "Ponominalu returned an error -200: 'Test error'"\
        " after calling method 'The method name'"
      message << " without parameters."
      message << " App session is '123'."

      expect(error.message).to eq(message)
    end
  end
end