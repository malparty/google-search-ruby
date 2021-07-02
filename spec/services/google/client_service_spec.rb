# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Google::ClientService, type: :service do
  describe '#call' do
    context 'when querying a simple keyword' do
      it 'returns an HTTParty Response', vcr: 'google_search/base' do
        result = described_class.new(keyword: FFaker::Lorem.word).call

        expect(result).to be_an_instance_of(HTTParty::Response)
      end

      it 'queries Google Search', vcr: 'google_search/base' do
        path = described_class.new(keyword: FFaker::Lorem.word).call.request.path

        expect(path.to_s).to start_with(described_class::BASE_SEARCH_URL)
      end
    end

    context 'when google returns an HTTP error' do
      it 'returns false', vcr: 'google_search/too_many_requests' do
        result = described_class.new(keyword: FFaker::Lorem.word).call

        expect(result).to eq(false)
      end

      it 'logs a warning with the escaped keyword', vcr: 'google_search/too_many_requests' do
        allow(Rails.logger).to receive(:warn)

        word = FFaker::Lorem.word
        described_class.new(keyword: word).call

        expect(Rails.logger).to have_received(:warn).with(/#{CGI.escape(word)}/)
      end
    end
  end
end
