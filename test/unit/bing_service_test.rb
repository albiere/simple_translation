require 'minitest_helper'

class BingServiceTest < Minitest::Test
  include Helpers::Fixtures

  def setup
    @credential_response = load_fixture('credential_response.json')
    @translation_response = load_fixture('bing_response_pt_en.xml')

    SimpleTranslation.config do |config|
      config.service = :bing
      config.bing_client_id = 'client_id'
      config.bing_client_secret = 'client_secret'
    end
    @translator = SimpleTranslation::Translator.new('This is a ball')
  end

  def test_build_translate_hash
    expected_hash = {
      from: 'en',
      to: 'pt',
      text: 'This is a ball',
      appId: '',
      contentType: 'text/plain'
    }

    hash = @translator.service.build_translate_hash('en', 'pt') 
    assert_equal expected_hash, hash
  end

  def test_translation_url
    assert_equal 'http://api.microsofttranslator.com/V2/Http.svc/Translate', @translator.service.class.translation_url
  end

  def test_build_credential_hash
    expected_hash = {
      client_id: 'client_id',
      client_secret: 'client_secret',
      grant_type: 'client_credentials',
      scope: 'http://api.microsofttranslator.com'
    }

    hash = @translator.service.build_credential_hash
    assert_equal expected_hash, hash
  end

  def test_credential_url
    assert_equal 'https://datamarket.accesscontrol.windows.net/v2/OAuth2-13', @translator.service.class.credential_url
  end

  def test_parse_translation_response_success
    response = Struct.new(:body, :status).new(@translation_response, 200)

    response = @translator.service.parse_translation_response(response)
    
    assert_kind_of SimpleTranslation::TranslationResponse, response
    assert_equal 'translation', response.text
  end

  def test_parse_translation_response_error
    response = Struct.new(:body, :status).new(@translation_response, 400)

    assert_raises(SimpleTranslation::TranslateRequestError) do
      @translator.service.parse_translation_response(response)
    end
  end

  def test_parse_credential_response_success
    response = Struct.new(:body, :status).new(@credential_response, 200)

    response = @translator.service.parse_credential_response(response)
    assert_equal 'my token', response
  end
  
  def test_parse_credential_response_error
    response = Struct.new(:body, :status).new(@credential_response, 400)

    assert_raises(SimpleTranslation::InvalidCredentialError) do
      @translator.service.parse_credential_response(response)
    end
  end

end
