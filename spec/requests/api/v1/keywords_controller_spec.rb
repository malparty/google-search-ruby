# frozen_string_literal: true

require 'rails_helper'

describe API::V1::KeywordsController, type: :request do
  describe 'GET #index' do
    context 'given an unauthenticated user' do
      it 'returns a 401 status code' do
        get :index

        expect(response.status).to eq(401)
      end
    end

    context 'when keyword_list is empty' do
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
      it 'returns the keywords for that page' do
        user = Fabricate(:user)
        Fabricate.times(51, :keyword, user: user)

        create_token_header(user)

        get :index, params: { page: 2 }

        expect(JSON.parse(response.body)['data'].count).to eq(1)
      end
    end

    context 'given an invalid page param' do
      it 'returns a 422 Unprocessable Entity status code' do
        user = Fabricate(:user)
        Fabricate.times(51, :keyword, user: user)

        create_token_header(user)

        get :index, params: { page: 10 }

        expect(response.status).to eq(422)
      end
    end
  end

  describe 'POST #create' do
    context 'given an invalid file' do
      it 'does not save any new keyword' do
        create_token_header

        params = file_params 'too_many_keywords.csv'

        expect { post :create, params: params }.to change(Keyword, :count).by(0)
      end

      it 'returns an errors object' do
        create_token_header

        post :create, params: file_params('too_many_keywords.csv')

        expect(JSON.parse(response.body)['errors'].keys).to contain_exactly('details', 'code', 'status')
      end

      it 'respondS with a 422 Unprocessable Entity status code' do
        create_token_header

        post :create, params: file_params('too_many_keywords.csv')

        expect(response.status).to eq(422)
      end
    end

    context 'given a valid file' do
      it 'saves the keywords in the DB' do
        create_token_header

        params = file_params 'valid.csv'

        expect { post :create, params: params }.to change(Keyword, :count).by(8)
      end

      it 'returns a success meta message' do
        create_token_header

        post :create, params: file_params('valid.csv')

        expect(JSON.parse(response.body)['meta']).to eq(I18n.t('csv.upload_success'))
      end

      it 'responds with a 200 OK status code' do
        create_token_header

        post :create, params: file_params('valid.csv')

        expect(response.status).to eq(200)
      end
    end
  end
end
