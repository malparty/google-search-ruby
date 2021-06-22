# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Google::ClientService, type: :service do
  context 'when querying a simple keyword' do
    it 'returns an HTTParty Response', vcr: 'google_search' do
<<<<<<< HEAD
      result = described_class.query(FFaker::Lorem.word)
=======
      result = described_class.new(FFaker::Lorem.word).call
>>>>>>> d03ca6f ([#7] Rename GoogleService namespace in Google)

      expect(result).to be_an_instance_of(HTTParty::Response)
    end

    it 'queries Google Search', vcr: 'google_search' do
<<<<<<< HEAD
      path = described_class.query(FFaker::Lorem.word).request.path
=======
      path = described_class.new(FFaker::Lorem.word).call.request.path
>>>>>>> d03ca6f ([#7] Rename GoogleService namespace in Google)

      expect(path.to_s).to start_with('https://www.google.com/search')
    end
  end
end
