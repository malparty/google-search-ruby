# frozen_string_literal: true

require 'rails_helper'

describe Doorkeeper::TokensController, type: :request do

  context 'when user ask for a token with good request' do
    it 'return a refreshable token' do
      post 'create', params: token_request_params
      expect(JSON.parse(response.body)['token_type']).to eq('Bearer')
    end
  end

  context 'when user ask for a token without client secret' do
    it 'return invalid_client error' do
      params = token_request_params
      params.except!(:client_secret)

      post 'create', params: params

      expect(JSON.parse(response.body)['error']).to eq('invalid_client')
    end
  end

  context 'when user ask for a token with bad credentials' do
    it 'return invalid_grant error' do
      params = token_request_params
      params[:password] = 'wrong_pass'

      post 'create', params: params

      expect(JSON.parse(response.body)['error']).to eq('invalid_grant')
    end
  end
end
