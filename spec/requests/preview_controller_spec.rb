# frozen_string_literal: true

require 'rails_helper'

describe PreviewController, type: :request do
  describe 'GET #show' do
    context 'given a valid id' do
      it 'returns a 200 status code' do
        keyword = Fabricate :keyword

        sign_in keyword.user

        get :index, params: { keyword_id: keyword.id }

        expect(response.status).to eq(200)
      end
    end

    context 'given an invalid id' do
      it 'responds with a 404 status code', authenticated_request_user: true do
        get :index, params: { keyword_id: 0 }

        expect(response.status).to eq(404)
      end
    end
  end
end
