require 'minitest_helper'

class BingTest < Minitest::Test
  include SimpleTranslation::Test::Fixtures

  def setup    
    credential_response = load_fixture('credential_response.json')
    translate_response = load_fixture('translate_response.xml')

    @credential_success = Struct.new(:body, :status).new(credential_response, 200)
    @credential_error = Struct.new(:body, :status).new(credential_response, 400)
    
    @translate_success = Struct.new(:body, :status).new(translate_response, 200)
    @translate_error = Struct.new(:body, :status).new(translate_response, 400)

    @credentials = { client_id: 'id', client_secret: 'secret' }
  end

  def test_request_credentials
    url = 'https://datamarket.accesscontrol.windows.net/v2/OAuth2-13' 
    post_params = { 
      'client_id' => @credentials[:client_id],
      'client_secret' => @credentials[:client_secret],
      'grant_type' => 'client_credentials',
      'scope' => 'http://api.microsofttranslator.com'
    }
    
    RequestHandler.expects(:post).with(url, post_params).returns(@credential_success)
    Bing.new(@credentials).request_token
  end

  def test_process_request_credentials_success
    RequestHandler.stubs(:post).returns(@credential_success)
    assert_equal 'access_token', Bing.new(@credentials).request_token
  end

  def test_process_request_credentials_error
    RequestHandler.stubs(:post).returns(@credential_error)

    assert_raises(InvalidCredentialError) do
      Bing.new(@credentials).request_token
    end
  end

  def test_request_translate
    url = 'http://api.microsofttranslator.com/V2/Http.svc/Translate'
    post_params = {
      'appId' => '',
      'from' => 'pt',
      'to' => 'en',
      'text' => 'bola',
      'contentType' => 'text/plain',
      'authorization' => 'authorization'
    }
    
    request = Bing.new(@credentials)

    request.stubs(:request_token).returns('authorization')
    RequestHandler.expects(:post).with(url, post_params).returns(@translate_success)

    request.translate('bola', from: 'pt', to: 'en')
  end

  def test_process_request_translate_success
    bing = Bing.new(@credentials)

    bing.stubs(:request_token).returns('authorization')
    RequestHandler.stubs(:post).returns(@translate_success)

    response = bing.translate('bola', from: 'pt', to: 'en')

    assert_kind_of TranslationResponse, response
    assert_equal 'translation', response.text
  end

  def test_process_request_translate_error
    bing = Bing.new(@credentials)

    bing.stubs(:request_token).returns('authorization')
    RequestHandler.stubs(:post).returns(@translate_error)

    assert_raises(TranslateRequestError) do
      bing.translate('bola', from: 'pt', to: 'en')
    end
  end

end
