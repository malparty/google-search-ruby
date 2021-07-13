# frozen_string_literal: true

module Google
  class ParserService
    NON_ADS_RESULT_SELECTOR = 'a[data-ved]:not([role]):not([jsaction]):not(.adwords):not(.footer-links)'
    AD_CONTAINER_ID = 'tads'
    ADWORDS_CLASS = 'adwords'

    def initialize(html_response:)
      raise ArgumentError, 'response.body cannot be blank' if html_response.body.blank?

      @html = html_response

      @document = Nokogiri::HTML.parse(html_response)

      # Add a class to all AdWords link for easier manipulation
      document.css('div[data-text-ad] a[data-ved]').add_class(ADWORDS_CLASS)

      # Mark footer links to identify them
      document.css('#footcnt a').add_class('footer-links')
    end

    # Parse html data and return a hash with the results
    def call
      {
        ads_top_count: ads_top_count,
        ads_page_count: ads_page_count,
        non_ads_result_count: non_ads_result_count,
        total_link_count: total_link_count,

        html: html,

        result_links: result_links,

        status: :parsed
      }
    end

    private

    attr_reader :html, :document

    def ads_top_count
      document.css("##{AD_CONTAINER_ID} .#{ADWORDS_CLASS}").count
    end

    def ads_page_count
      document.css(".#{ADWORDS_CLASS}").count
    end

    def ads_top_urls
      document.css("##{AD_CONTAINER_ID} .#{ADWORDS_CLASS}").filter_map { |a_tag| a_tag['href'].presence }
    end

    def ads_page_urls
      document.css(".#{ADWORDS_CLASS}").filter_map { |a_tag| a_tag['href'].presence }
    end

    def non_ads_result_count
      document.css(NON_ADS_RESULT_SELECTOR).count { |a_tag| a_tag['href'].presence }
    end

    def non_ads_urls
      document.css(NON_ADS_RESULT_SELECTOR).filter_map { |a_tag| a_tag['href'].presence }
    end

    def total_link_count
      document.css('a').count
    end

    def result_links
      results = result_link_map(ads_page_urls, :ads_page)
      results += result_link_map(non_ads_urls, :non_ads)
      results += result_link_map(ads_top_urls, :ads_top)

      results
    end

    def result_link_map(urls, type)
      urls.map do |url|
        { url: url, link_type: type }
      end
    end
  end
end
