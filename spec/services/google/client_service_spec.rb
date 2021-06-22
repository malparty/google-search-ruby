# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Google::ClientService, type: :service do
  context 'when querying a simple keyword' do
    it 'returns an HTTParty Response', vcr: 'google_search' do
      result = described_class.new(keyword: FFaker::Lorem.word).call

      expect(result).to be_an_instance_of(HTTParty::Response)
    end

    it 'queries Google Search', vcr: 'google_search' do
      path = described_class.new(keyword: FFaker::Lorem.word).call.request.path

      expect(path.to_s).to start_with('https://www.google.com/search')
    end
  end

  context 'when google returns an HTTP error' do
    it 'returns a nil result', vcr: 'google_warn' do
      result = described_class.new(keyword: FFaker::Lorem.word).call

      expect(result).to be_nil
    end

    it 'logs a warning with the escaped keyword', vcr: 'google_warn' do
      allow(Rails.logger).to receive(:warn)

      word = FFaker::Lorem.word
      described_class.new(keyword: word).call

      expect(Rails.logger).to have_received(:warn).with(/#{CGI.escape(word)}/)
    end
  end
end
