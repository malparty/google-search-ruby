# frozen_string_literal: true

require 'rails_helper'

describe API::V1::KeywordsController, type: :request do
  describe '#index' do
    context 'given an unauthenticated user' do
      it 'returns a 401 status code' do
        get :index

        expect(response.status).to eq(401)
      end
    end

    context 'when no keywords' do
      it 'returns a meta message' do
        create_token_header(Fabricate(:user))

        get :index

        expect(JSON.parse(response.body)['meta']).to eq(I18n.t('keywords.empty_list'))
      end

      it 'returns an empty data array' do
        create_token_header(Fabricate(:user))

        get :index

        expect(JSON.parse(response.body)['data'].count).to eq(0)
      end
    end

    context 'when more than a page of keywords' do
      it 'returns the first page of keywords' do
        user = Fabricate(:user)
        Fabricate.times(51, :keyword, user: user)

        create_token_header(user)

        get :index

        expect(JSON.parse(response.body)['data'].count).to eq(50)
      end

      it 'returns the total pages meta info' do
        user = Fabricate(:user)
        Fabricate.times(51, :keyword, user: user)

        create_token_header(user)

        get :index

        expect(JSON.parse(response.body)['meta']['total_pages']).to eq(2)
      end

      it 'returns the links to related pages' do
        user = Fabricate(:user)
        Fabricate.times(51, :keyword, user: user)

        create_token_header(user)

        get :index

        expect(JSON.parse(response.body)['links'].keys).to contain_exactly('self', 'first', 'prev', 'next', 'last')
      end
    end

    context 'given a valid page param' do
      it 'returns the keywords to that page' do
        user = Fabricate(:user)
        Fabricate.times(51, :keyword, user: user)

        create_token_header(user)

        get :index, params: { page: 2 }

        expect(JSON.parse(response.body)['data'].count).to eq(1)
      end
    end

    context 'given an invalid page param' do
      it 'returns a 422 Unprocessable Entity' do
        user = Fabricate(:user)
        Fabricate.times(51, :keyword, user: user)

        create_token_header(user)

        get :index, params: { page: 10 }

        expect(response.status).to eq(422)
      end
    end
  end
end