module SimpleTranslation
  class Configuration
    class << self

      attr_accessor :service, :bing_client_id, :bing_client_secret

      def configure(&block)
        block.call(self)
      end

    end  
  end
end
