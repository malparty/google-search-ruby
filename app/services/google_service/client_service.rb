# frozen_string_literal: true

module GoogleService
  class ClientService

    USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) '\
                'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.77 Safari/537.36'

    BASE_SEARCH_URL2 = 'https://google.com/search'

    def initialize(keyword, lang = 'en')
      escaped_keyword = CGI.escape(keyword)
      @uri = URI("#{BASE_SEARCH_URL2}?q=#{escaped_keyword}&hl=#{lang}&gl=#{lang}")
    end

    def query_result
      begin
        @result = HTTParty.get(@uri, { headers: { 'User-Agent' => USER_AGENT } })
      rescue HTTParty::Error, Timeout::Error, SocketError => e
        Rails.logger.error "Error: Query Google with keyword #{@keyword} throw an error: #{e}".colorize(:red)
        @result = nil
      else
        validate_result
      end
      @result
    end

    private

    # Inspect Http response status code
    # Any non 200 response code will be logged
    # response is set to nil in order to notify the error
    def validate_result
      return if @result.response.code == '200'

      Rails.logger.warn "Warning: Query Google with keyword #{@keyword} return status code #{@result.response.code}"
                          .colorize(:yellow)
      @result = nil
    end
  end
end
