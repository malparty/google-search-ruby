# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Google::SearchKeywordJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    context 'given a valid request' do
      it 'queues the job', vcr: 'google_search/top_ads_1' do
        keyword = Fabricate(:keyword)

        expect { described_class.perform_later keyword.id }.to have_enqueued_job(described_class)
      end

      it 'saves all result_links in the DataBase', vcr: 'google_search/top_ads_1' do
        keyword = Fabricate(:keyword)

        described_class.perform_now keyword.id

        expect(keyword.result_links.count).to eq(46)
      end

      it 'sets the keyword status as parsed', vcr: 'google_search/top_ads_1' do
        keyword = Fabricate(:keyword)

        described_class.perform_now keyword.id

        expect(keyword.reload.status).to eq('parsed')
      end

      it 'sets the links counts with the right values', vcr: 'google_search/top_ads_1' do
        keyword = Fabricate(:keyword)

        described_class.perform_now keyword.id

        keyword.reload

        expect(keyword.ads_top_count + keyword.ads_page_count + keyword.non_ads_result_count).to eq(46)
      end

      it 'sets the keyword html attribute', vcr: 'google_search/top_ads_1' do
        keyword = Fabricate(:keyword)

        described_class.perform_now keyword.id

        expect(keyword.reload.html).to be_present
      end

      it 'performs a SearchProgress job with the right user id', vcr: 'google_search/top_ads_1' do
        keyword = Fabricate(:keyword)

        allow(Google::SearchProgressJob).to receive(:perform_now)

        described_class.perform_now keyword.id

        expect(Google::SearchProgressJob).to have_received(:perform_now).with(keyword.user_id).exactly(:once)
      end
    end

    context 'given a 422 too many requests error' do
      it 'sets the keyword status as failed', vcr: 'google_search/too_many_requests' do
        keyword = Fabricate(:keyword)

        described_class.perform_now keyword.id

      rescue Google::ClientServiceError
        expect(keyword.reload.status).to eq('failed')
      end

      it 'does not save any result_links', vcr: 'google_search/too_many_requests' do
        keyword = Fabricate(:keyword)

        described_class.perform_now keyword.id

      rescue Google::ClientServiceError
        expect(keyword.reload.result_links.count).to eq(0)
      end

      it 'does not set any result count', vcr: 'google_search/too_many_requests' do
        keyword = Fabricate(:keyword)

        described_class.perform_now keyword.id

      rescue Google::ClientServiceError
        keyword.reload

        expect([keyword.ads_top_count, keyword.ads_page_count, keyword.non_ads_result_count]).to all(be_nil)
      end

      it 'does not set the html attribute', vcr: 'google_search/too_many_requests' do
        keyword = Fabricate(:keyword)

        described_class.perform_now keyword.id

      rescue Google::ClientServiceError
        expect(keyword.reload.html).not_to be_present
      end

      it 'performs a SearchProgress job with the right user id', vcr: 'google_search/too_many_requests' do
        keyword = Fabricate(:keyword)

        allow(Google::SearchProgressJob).to receive(:perform_now)

        described_class.perform_now keyword.id

      rescue Google::ClientServiceError
        expect(Google::SearchProgressJob).to have_received(:perform_now).with(keyword.user_id).exactly(:once)
      end
    end
  end
end
