require 'minitest_helper'

class BingTest < Minitest::Test
  include SimpleTranslation

  def setup
    @params = { 
      client_id: 'id', 
      client_secret: 'secret',
      from: 'pt', 
      to: 'en', 
      text: 'bola'
    }
  end

  def test_request_credentials
    url = 'https://datamarket.accesscontrol.windows.net/v2/OAuth2-13' 
    post_params = { 
      'client_id' => @params[:client_id],
      'client_secret' => @params[:client_secret],
      'grant_type' => 'client_credentials',
      'scope' => 'http://api.microsofttranslator.com'
    }
    faraday_response = Struct.new(:body, :status).new("{\"token_type\":\"token_type\",\"access_token\":\"access_token\",\"expires_in\":\"599\",\"scope\":\"scope\"}", 200)
  
    Faraday.expects(:post).with(url, post_params).returns(faraday_response)
    Bing.new(@params).request_token
  end

  def test_process_request_credentials_success
   faraday_response = Struct.new(:body, :status).new("{\"token_type\":\"token_type\",\"access_token\":\"access_token\",\"expires_in\":\"599\",\"scope\":\"scope\"}", 200)

   Faraday.stubs(:post).returns(faraday_response)
   assert_equal 'access_token', Bing.new(@params).request_token
  end

  def test_process_request_credentials_error
   faraday_response = Struct.new(:body, :status).new("{\"token_type\":\"token_type\",\"access_token\":\"access_token\",\"expires_in\":\"599\",\"scope\":\"scope\"}", 400)

   Faraday.stubs(:post).returns(faraday_response)

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
    faraday_response = Struct.new(:body, :status).new('<string xmlns="http://schemas.microsoft.com/2003/10/Serialization/">translation</string>', 200)
    
    request = Bing.new(@params)

    request.stubs(:request_token).returns('authorization')
    Faraday.expects(:post).with(url, post_params).returns(faraday_response)

    request.translate
  end

  def test_process_request_translate_success
    faraday_response = Struct.new(:body, :status).new('<string xmlns="http://schemas.microsoft.com/2003/10/Serialization/">translation</string>', 200)
    request = Bing.new(@params)

    request.stubs(:request_token).returns('authorization')
    Faraday.stubs(:post).returns(faraday_response)

    assert_kind_of TranslationResponse, request.translate
    assert_equal 'translation', request.translate.text
  end

  def test_process_request_translate_error
    faraday_response = Struct.new(:body, :status).new('<string xmlns="http://schemas.microsoft.com/2003/10/Serialization/">translation</string>', 400)
    request = Bing.new(@params)

    request.stubs(:request_token).returns('authorization')
    Faraday.stubs(:post).returns(faraday_response)

    assert_raises(TranslateRequestError) do
      request.translate
    end
  end

end
