require 'minitest_helper'

class TranslatorTest < Minitest::Test
  include Helpers::FakeRequest
  include Helpers::Fixtures
  include Helpers::TestClasses

  def setup
    @credential_url = 'https://datamarket.accesscontrol.windows.net/v2/OAuth2-13'
    @translate_url = 'http://api.microsofttranslator.com/V2/Http.svc/Translate'
    @response = load_fixture('bing_response_en_pt.xml')
    @credential_response = load_fixture('credential_response.json')

    fake_request(@translate_url, @response)
    fake_request(@credential_url, @credential_response)
    fake_request('http://testurl.com', nil)
  end

  def test_call_translate_interface
    SimpleTranslation.config do |config|
      config.service = :bing
      config.bing_client_id = 'client_id'
      config.bing_client_secret = 'client_secret'
    end

    translator = SimpleTranslation::Translator.new('To be translated')

    translator.service.class.expects(:translation_url).returns(@translate_url)
    translator.service.expects(:parse_translation_response)

    translator.translate(from: 'pt', to: 'en')
  end

  def test_call_credential_when_existent    
    SimpleTranslation.config do |config|
      config.service = :bing
      config.bing_client_id = 'client_id'
      config.bing_client_secret = 'client_secret'
    end

    translator = SimpleTranslation::Translator.new('To be translated')

    translator.service.class.expects(:credential_url).returns(@credential_url)
    translator.service.expects(:parse_credential_response)

    translator.translate(from: 'pt', to: 'en')
  end

  def test_not_call_credential_when_inexistent
    # Need a better solution - I yet don't know
    SimpleTranslation::Configuration.stubs(:service).returns(:bing)
    SimpleTranslation::BingService.stubs(:new).returns(TestService.new('To be translated'))

    translator = SimpleTranslation::Translator.new('To be translated')
    translator.service.class.expects(:parse_credential_response).never

    translator.translate(from: 'pt', to: 'en')
  end
  
  def test_translation_without_service
    SimpleTranslation.config do |config|
      config.service = nil
    end  

    assert_raises(SimpleTranslation::ServiceNotFoundError) do
      SimpleTranslation::Translator.new('To be translated')    
    end
  end

  def test_translation_with_unknown_service
    SimpleTranslation.config do |config|
      config.service = :unknown
    end  

    assert_raises(SimpleTranslation::ServiceNotFoundError) do
      SimpleTranslation::Translator.new('To be translated')    
    end
  end

  def test_translation_without_text
    SimpleTranslation.config do |config|
      config.service = :bing
    end

    assert_raises(SimpleTranslation::TextNotFoundError) do
      SimpleTranslation::Translator.new('')
    end

    assert_raises(SimpleTranslation::TextNotFoundError) do
      SimpleTranslation::Translator.new(nil)
    end
  end

end
