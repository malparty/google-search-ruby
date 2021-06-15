# frozen_string_literal: true

module GoogleService
  class ParserService
    require 'nokogiri'

    def initialize(html)
      @html = html
      @document = Nokogiri::HTML.parse(html)
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
      @document.css('#tads div[data-text-ad]').count
    end

    def ads_page_count
      @document.css('div[data-text-ad]').count
    end

    def ads_top_url
      # data-ved enables to filter "role=list" (sub links) items
      @document.css('#tads div[data-text-ad] a[data-ved]').map { |a_tag| a_tag['href'] }
    end

    def ads_page_url

    end

    def non_ads_result_count

    end

    def total_link_count

    end
  end
end
