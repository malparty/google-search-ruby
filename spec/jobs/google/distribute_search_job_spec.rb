# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Google::DistributeSearchJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    context 'given 3 valid keywords' do
      it 'queues a DistributedSearch job' do
        keywords = Fabricate.times(3, :keyword).map(&:id)

        expect { described_class.perform_later keywords }.to have_enqueued_job(described_class)
      end

      it 'queues 3 SearchKeyword jobs' do
        keywords = Fabricate.times(3, :keyword).map(&:id)

        expect { described_class.perform_now keywords }.to have_enqueued_job(Google::SearchKeywordJob).exactly(:thrice)
      end
    end

    context 'given an empty array' do
      it 'queues a DistributedSearch job' do
        expect { described_class.perform_later [] }.to have_enqueued_job(described_class)
      end

      it 'does not queue the SearchKeyword jobs' do
        expect { described_class.perform_now [] }.not_to have_enqueued_job(Google::SearchKeywordJob)
      end
    end
  end
end
