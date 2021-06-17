# frozen_string_literal: true

require 'rails_helper'

describe API::V1::UsersController, type: :request do
  context 'when a user register' do
    it 'returns the user' do
      params = create_user_params
      params[:email] = 'new_email@gmail.com'
      post 'create', params: params

      expect(JSON.parse(response.body)['data'].map { |item| item['type'] }).to contain_exactly('user', 'token')
    end
  end

  context 'when a user register with an existing email' do
    it 'receive an error' do
      params = create_user_params
      post 'create', params: params

      expect(JSON.parse(response.body).keys).to contain_exactly('errors')
    end
  end

  context 'when a user register with a non valid password' do
    it 'receive an error' do
      params = create_user_params
      params[:password] = '123'
      post 'create', params: params

      expect(JSON.parse(response.body).keys).to contain_exactly('errors')
    end
  end

  context 'when a user register with a non valid Client Id' do
    it 'receive an error' do
      params = create_user_params
      params[:client_id] = 'not valid'
      post 'create', params: params

      expect(JSON.parse(response.body).keys).to contain_exactly('errors')
    end
  end
end
