require 'spec_helper'

describe Ponominalu::Middleware do
  let(:logger) { double("Logger").as_null_object }
  let(:app) { double("App").as_null_object }
  let(:url) { double('URL', to_s: Ponominalu::API::BASE_URL + '/test_method' ) }

  let(:env_request) { double('Env object', body: 'param_1=1&param_2=2',
      url: url, status: 200) }

  let(:env_success) { double('Env success object',
    body: double('Body', code: 1) , status: 200) }

  let(:env_empty) { double('Env empty object', body: double('Body', code: 0),
    status: 200) }

  let(:api_error) { double('API error body', code: -200, message: 'API error',
    method_name: 'test_method', session: Ponominalu.session, params: {} ) }

  let(:env_api_error) { double('Env api error object', body: api_error,
    status: 200) }

  let(:env_fail) { double('Env fail object', body: double('Body', code: 1),
    status: 404) }

  before(:each) do
    Ponominalu.logger = logger
    Ponominalu.session = 'test_session'
    Ponominalu.log_requests  = false
    Ponominalu.log_responses = false
  end

  subject { Ponominalu::Middleware.new(app) }

  context 'when request is processing' do
    it 'calls debug method on the logger with correct messages' do
      Ponominalu.log_requests = true
      expect(logger).to receive(:debug)
        .with('Ponominalu: TEST_METHOD '\
          'http://api.cultserv.ru/jtransport/test_method')
      expect(logger).to receive(:debug)
        .with('session: test_session params: {"param_1"=>"1", "param_2"=>"2"}')
      subject.call(env_request)
    end

    it 'adds the session param to the request body' do
      expect(env_request.body).to receive(:<<)
        .with('&session=test_session')
      subject.call(env_request)
    end
  end

  context 'when response is processing' do
    before(:each) do
      Oj.stub(:load).and_return({})
    end

    context '(logging)' do
      before(:each) { subject.stub(:raise) }

      it 'calls warn method on the logger if result is empty' do
        env_empty.stub(:body=)

        expect(logger).to receive(:warn)
          .with('Nothing was found. Result is empty.')
        subject.on_complete(env_empty)
      end

      it 'calls error method on the logger if API error is returned' do
        env_api_error.stub(:body=)

        expect(logger).to receive(:error)
          .with('-200: API error.')
        subject.on_complete(env_api_error)
      end

      it 'calls error method on the logger if API error is returned' do
        env_fail.stub(:body=)

        expect(logger).to receive(:error)
          .with('Request failed with status code 404.')
        subject.on_complete(env_fail)
      end

      it 'calls debug method on the logger if log_responses is true' do
        env_success.stub(:body=)

        Ponominalu.log_responses = true

        expect(logger).to receive(:debug)
          .with("body: #{env_success.body}")
        subject.on_complete(env_success)
      end
    end

    context '(error raising)' do
      it 'raises runtime error if response status is not 200' do
        env_fail.stub(:body=)

        expect { subject.on_complete(env_fail) }.to \
          raise_error(RuntimeError, 'Request failed with status code 404.')
      end

      it 'raises Ponominalu::Error if response code is negative number' do
        env_api_error.stub(:body=)

        expect { subject.on_complete(env_api_error) }.to \
          raise_error(Ponominalu::Error)
      end
    end
  end
end