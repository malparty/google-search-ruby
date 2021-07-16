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
    end

    context 'given a 422 too many requests error' do
      it 'sets the keyword status as failed', vcr: 'google_search/too_many_requests' do
        keyword = Fabricate(:keyword)

        described_class.perform_now keyword.id

        expect(keyword.reload.status).to eq('failed')
      end

      it 'retries the job when an error is raised' do
        allow(described_class).to receive(:retry_on)

        load 'app/jobs/google/search_keyword_job.rb'

        expect(described_class).to have_received(:retry_on).with(Google::ClientServiceError, ArgumentError)
      end

      it 'does not save any result_links', vcr: 'google_search/too_many_requests' do
        keyword = Fabricate(:keyword)

        described_class.perform_now keyword.id

        expect(keyword.reload.result_links.count).to eq(0)
      end

      it 'does not set any result count', vcr: 'google_search/too_many_requests' do
        keyword = Fabricate(:keyword)

        keyword.reload

        expect([keyword.ads_top_count, keyword.ads_page_count, keyword.non_ads_result_count]).to all(be_nil)
      end

      it 'does not set the html attribute', vcr: 'google_search/too_many_requests' do
        keyword = Fabricate(:keyword)

        described_class.perform_now keyword.id

        expect(keyword.reload.html).not_to be_present
      end
    end
  end
end
