# frozen_string_literal: true

module GoogleService
  class ParserService
    require 'nokogiri'

    NON_ADS_RESULT_SELECTOR = 'a[data-ved]:not([role]):not([jsaction]):not(.adwords):not(.footer-links)'

    def initialize(html_response:)
      raise ArgumentError, 'response.body cannot be nil' if html_response.body.blank?

      @html = html_response

      @document = Nokogiri::HTML.parse(html_response)

      # Add a class to all AdWords link for easier manipulation
      @document.css('div[data-text-ad] a[data-ved]').add_class('adwords')

      # Mark footer links to identify them
      @document.css('#footcnt a').add_class('footer-links')
    end

    def parse_into(keyword)
      keyword.ads_top_count = ads_top_count
      keyword.ads_page_count = ads_page_count
      keyword.ads_top_url = ads_top_url
      keyword.ads_page_url = ads_page_url
      keyword.non_ads_result_count = non_ads_result_count
      keyword.total_link_count = total_link_count
      keyword.html = @html
    end

    def ads_top_count
      @document.css('#tads .adwords').count
    end

    def ads_page_count
      @document.css('.adwords').count
    end

    def ads_top_url
      # data-ved enables to filter "role=list" (sub links) items
      @document.css('#tads .adwords').map { |a_tag| a_tag['href'] }
    end

    def ads_page_url
      @document.css('.adwords').map { |a_tag| a_tag['href'] }
    end

    def non_ads_result_count
      @document.css(NON_ADS_RESULT_SELECTOR).count
    end

    def non_ads_url
      @document.css(NON_ADS_RESULT_SELECTOR).map { |a_tag| a_tag['href'] }
    end

    def total_link_count
      @document.css('a').count
    end
  end
end
