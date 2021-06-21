# frozen_string_literal: true

require 'rails_helper'

describe API::V1::UsersController, type: :request do
  context 'when a user registers' do
    it 'returns the user' do
      post :create, params: create_user_params.merge!({ email: 'new_email@gmail.com' })

      expect(JSON.parse(response.body)['data']['type']).to eq('user')
    end
  end

  context 'when a user registers with an existing email' do
    it 'receives an error' do
      post :create, params: create_user_params

      expect(JSON.parse(response.body).keys).to contain_exactly('errors')
    end
  end

  context 'when a user registers with a non valid password' do
    it 'receives an error' do
      post :create, params: create_user_params.merge!({ password: '123' })

      expect(JSON.parse(response.body).keys).to contain_exactly('errors')
    end
  end

  context 'when a user registers with a non valid Client Id' do
    it 'receives an error' do
      post :create, params: create_user_params.merge!({ client_id: 'not valid' })

      expect(JSON.parse(response.body).keys).to contain_exactly('errors')
    end
  end
end
