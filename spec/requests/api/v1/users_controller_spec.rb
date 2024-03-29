# frozen_string_literal: true

require 'rails_helper'

describe API::V1::UsersController, type: :request do
  context 'when a user registers' do
    context 'given valid params' do
      it 'returns the user' do
        post :create, params: create_user_params.merge(email: 'new_email@gmail.com')

        expect(JSON.parse(response.body)['data']['type']).to eq('user')
      end
    end

    context 'given an existing email' do
      it 'receives an error' do
        post :create, params: create_user_params

        expect(JSON.parse(response.body).keys).to contain_exactly('errors')
      end
    end

    context 'given an invalid password' do
      it 'receives an error' do
        post :create, params: create_user_params.merge(password: '123')

        expect(JSON.parse(response.body).keys).to contain_exactly('errors')
      end
    end

    context 'given an invalid client_id' do
      it 'receives an error' do
        post :create, params: create_user_params.merge(client_id: 'not valid')

        expect(JSON.parse(response.body).keys).to contain_exactly('errors')
      end
    end

    context 'given an invalid client_secret' do
      it 'receives an error' do
        post :create, params: create_user_params.merge(client_secret: 'not valid')

        expect(JSON.parse(response.body).keys).to contain_exactly('errors')
      end
    end
  end
end
