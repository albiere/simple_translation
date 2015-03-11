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

    @params = { client_id: 'id', 
                client_secret: 'secret',
                from: 'pt', 
                to: 'en', 
                text: 'bola' }
  end

  def test_request_credentials
    url = 'https://datamarket.accesscontrol.windows.net/v2/OAuth2-13' 
    post_params = { 
      'client_id' => @params[:client_id],
      'client_secret' => @params[:client_secret],
      'grant_type' => 'client_credentials',
      'scope' => 'http://api.microsofttranslator.com'
    }
    
    TranslationRequest.expects(:post).with(url, post_params).returns(@credential_success)
    Bing.new(@params).request_token
  end

  def test_process_request_credentials_success
    TranslationRequest.stubs(:post).returns(@credential_success)
    assert_equal 'access_token', Bing.new(@params).request_token
  end

  def test_process_request_credentials_error
    TranslationRequest.stubs(:post).returns(@credential_error)

    assert_raises(InvalidCredentialError) do
     Bing.new(@params).request_token
    end
  end

  def test_request_translate
    url = 'http://api.microsofttranslator.com/V2/Http.svc/Translate'
    post_params = {
      'appId' => '',
      'from' => @params[:from],
      'to' => @params[:to],
      'text' => @params[:text],
      'contentType' => 'text/plain',
      'authorization' => 'authorization'
    }
    
    request = Bing.new(@params)

    request.stubs(:request_token).returns('authorization')
    TranslationRequest.expects(:post).with(url, post_params).returns(@translate_success)

    request.translate
  end

  def test_process_request_translate_success
    request = Bing.new(@params)

    request.stubs(:request_token).returns('authorization')
    TranslationRequest.stubs(:post).returns(@translate_success)

    assert_kind_of TranslationResponse, request.translate
    assert_equal 'translation', request.translate.text
  end

  def test_process_request_translate_error
    request = Bing.new(@params)

    request.stubs(:request_token).returns('authorization')
    TranslationRequest.stubs(:post).returns(@translate_error)

    assert_raises(TranslateRequestError) do
      request.translate
    end
  end

end
