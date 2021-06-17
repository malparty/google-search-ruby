# frozen_string_literal: true

require 'rails_helper'

describe Doorkeeper::TokensController, type: :request do
  context 'when a user asks for a token with good request' do
    it 'returns a refreshable token' do
      post :create, params: token_request_params
      expect(JSON.parse(response.body)['token_type']).to eq('Bearer')
    end
  end

  context 'when a user asks for a token without client secret' do
    it 'returns an invalid_client error' do
      params = token_request_params.except!(:client_secret)

      post :create, params: params

      expect(JSON.parse(response.body)['error']).to eq('invalid_client')
    end
  end

  context 'when a user asks for a token with bad credentials' do
    it 'returns an invalid_grant error' do
      params = token_request_params.merge(password: 'wrong_pass')

      post :create, params: params

      expect(JSON.parse(response.body)['error']).to eq('invalid_grant')
    end
  end

  context 'when a user refreshes an existing token on time' do
    it 'returns the refreshed token' do
      token = query_token
      refreshed_token = query_refresh_token token['refresh_token']

      expect(refreshed_token['token_type']).to eq('Bearer')
    end
  end

  context 'when a user revokes an existing token' do
    it 'returns no error message' do
      token = query_token
      params = token_request_params.merge({ token: token })

      post :revoke, params: params

      expect(JSON.parse(response.body)).to eq({})
    end
  end
end
