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

  context 'when parsing a page having 3 top ads and 3 bottom ads' do
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

  end
end
