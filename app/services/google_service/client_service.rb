# frozen_string_literal: true

module GoogleService
  class ClientService
    require 'httparty'

    USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) '\
                'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.77 Safari/537.36'

    def initialize(keyword, lang = 'en')
      escaped_keyword = CGI.escape(keyword)
      @uri = URI("https://auibawsasxasxechjksdc.fr/search?q=#{escaped_keyword}&hl=#{lang}&gl=#{lang}")
    end

    # Inspect Http response status code
    # Any non 200 response code will be logged
    # response is set to nil in order to notify the error
    def validate_result
      return if @result.response.code == '200'

      Rails.logger.warn "Warning: Query Google with keyword #{@keyword} return status code #{@result.response.code}"
      @result = nil
    end

    def query_result
      begin
        @result = HTTParty.get(@uri, { headers: { 'User-Agent' => USER_AGENT } })
      rescue HTTParty::Error, Timeout::Error, SocketError => e
        Rails.logger.error "Error: Query Google with keyword #{@keyword} throw an error: #{e}"
        @result = nil
      else
        validate_result
      end
      @result
    end
  end
end
