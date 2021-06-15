# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GoogleService::ParserService, type: :service do
  context 'when parsing a result containing 1 top ads' do
    it 'count exactly 1 top ads' do
      result = nil
      VCR.use_cassette('google_search_top_ads_1') do
        result = GoogleService::ClientService.query('squarespace')
      end
      expect(described_class.new(result).ads_top_count).to eq(1)
    end
  end
end
