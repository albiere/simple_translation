require 'minitest_helper'

class SimpleTranslationTest < Minitest::Test
  
  def setup
    SimpleTranslation.config do |config|
      config.service = :bing
      config.bing_client_id = 'client_id'
      config.bing_client_secret = 'client_secret'
    end
  end

  def test_service_configuration
    assert_equal :bing, SimpleTranslation::Configuration.service
  end

  def test_bing_client_id_configuration
    assert_equal 'client_id', SimpleTranslation::Configuration.bing_client_id
  end

  def test_bing_client_secret_configuration
    assert_equal 'client_secret', SimpleTranslation::Configuration.bing_client_secret
  end

end
