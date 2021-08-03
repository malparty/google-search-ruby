# frozen_string_literal: true

require 'rails_helper'

describe KeywordsController, type: :request do
  describe 'POST #create' do
    context 'given a valid file' do
      it 'queues a Google::SearchKeyword job', authenticated_request_user: true do
        expect { post :create, params: file_params('valid.csv') }.to have_enqueued_job(Google::DistributeSearchJob)
      end
    end

    context 'given an invalid file' do
      it 'does not queue any job', authenticated_request_user: true do
        expect { post :create, params: file_params('too_many_keywords.csv') }.not_to have_enqueued_job
      end
    end
  end

  describe 'GET #show' do
    context 'given a valid id' do
      it 'returns a 200 status code' do
        keyword = Fabricate :keyword

        sign_in keyword.user

        get :show, params: { id: keyword.id }

        expect(response.status).to eq(200)
      end
    end

    context 'given an invalid id' do
      it 'responds with a 404 status code', authenticated_request_user: true do
        get :show, params: { id: 0 }

        expect(response.status).to eq(404)
      end
    end
  end
end
