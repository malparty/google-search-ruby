# frozen_string_literal: true

require 'rails_helper'

describe KeywordsController, type: :request do
  describe 'POST #create' do
    context 'given a valid file' do
      it 'queues a Google::SearchKeyword job', authenticated_request_user: true  do
        expect { post :create, params: file_params('valid.csv') }.to have_enqueued_job(Google::DistributeSearchJob)
      end
    end

    context 'given an invalid file' do
      it 'does not queue any job', authenticated_request_user: true do
        expect { post :create, params: file_params('too_many_keywords.csv') }.not_to have_enqueued_job
      end
    end
  end
end
