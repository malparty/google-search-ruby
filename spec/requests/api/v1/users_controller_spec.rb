# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::UsersController, type: :request do
  context 'when a user register' do
    it 'returns the user and access token' do
      params = create_user_params
      params[:email] = 'new_email@gmail.com'
      post 'create', params: params

      expect(JSON.parse(response.body).keys).to contain_exactly('user')
    end
  end

  context 'when a user register with an existing email' do
    it 'receive an error' do
      params = create_user_params
      post 'create', params: params

      expect(JSON.parse(response.body).keys).to contain_exactly('error')
    end
  end

  context 'when a user register with a non valid password' do
    it 'receive an error' do
      params = create_user_params
      params[:password] = '123'
      post 'create', params: params

      expect(JSON.parse(response.body).keys).to contain_exactly('error')
    end
  end
end
