# frozen_string_literal: true

module GoogleService
  class ClientService
    require 'httparty'

    def self.query(keyword, lang = 'en')
      encoded_keyword = URI.encode(keyword)
      uri = URI("https://google.com/search?q=#{encoded_keyword}&hl=#{lang}&gl=#{lang}")
      user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) '\
                'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.77 Safari/537.36'
      HTTParty.get(uri, { headers: { 'User-Agent' => user_agent } })
    end
  end
end
