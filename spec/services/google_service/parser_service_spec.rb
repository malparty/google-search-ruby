# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GoogleService::ParserService, type: :service do
  context 'when parsing a page having 1 top ads' do
    it 'counts exactly 1 top ads' do
      result = nil
      VCR.use_cassette('google_search_top_ads_1') do
        result = GoogleService::ClientService.query('squarespace')
      end

      expect(described_class.new(result).ads_top_count).to eq(1)
    end
  end

  context 'when parsing a page having 3 top ads, 3 bottom ads and 14 non ads links' do
    it 'counts exactly 3 top ads' do
      result = nil
      VCR.use_cassette('google_search_top_ads_6') do
        result = GoogleService::ClientService.query('vpn')
      end

      expect(described_class.new(result).ads_top_count).to eq(3)
    end

    it 'counts exactly 6 ads in total' do
      result = nil
      VCR.use_cassette('google_search_top_ads_6') do
        result = GoogleService::ClientService.query('vpn')
      end

      expect(described_class.new(result).ads_page_count).to eq(6)
    end

    it 'finds exactly the 3 top ads urls' do
      result = nil
      VCR.use_cassette('google_search_top_ads_6') do
        result = GoogleService::ClientService.query('vpn')
      end

      expect(described_class.new(result).ads_top_url).to contain_exactly('https://cloud.google.com/free', 'https://www.expressvpn.com/', 'https://www.top10vpn.com/best-vpn-for-vietnam/')
    end

    it 'counts exactly 14 non ads results' do
      result = nil
      VCR.use_cassette('google_search_top_ads_6') do
        result = GoogleService::ClientService.query('vpn')
      end

      expect(described_class.new(result).non_ads_result_count).to eq(14)
    end

    it 'gets 14 results' do
      result = nil
      VCR.use_cassette('google_search_top_ads_6') do
        result = GoogleService::ClientService.query('vpn')
      end

      expect(described_class.new(result).non_ads_url.count).to eq(14)
    end

    it 'gets exactly 113 links' do # Counted from cassette html raw code
      result = nil
      VCR.use_cassette('google_search_top_ads_6') do
        result = GoogleService::ClientService.query('vpn')
      end

      expect(described_class.new(result).total_link_count).to eq(113)
    end
  end
end
