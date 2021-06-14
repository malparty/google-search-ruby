# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GoogleService::ClientService, type: :service do
  context 'when querying a simple keyword' do
    it 'returns an HTTParty Response' do
      result = nil
      VCR.use_cassette('google_search') do
        result = described_class.query(FFaker::Lorem.word)
      end

      expect(result).to be_an_instance_of(HTTParty::Response)
    end

    it 'queries Google Search' do
      path = nil
      VCR.use_cassette('google_search') do
        path = described_class.query(FFaker::Lorem.word).request.path
      end

      expect(path.to_s).to start_with('https://www.google.com/search')
    end
  end
end
