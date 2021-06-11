# frozen_string_literal: true

module OAuthHelpers
  def token_request_params
    @user ||= Fabricate(:user)
    @application ||= Fabricate(:application)

    {
      grant_type: 'password',
      client_id: @application.uid,
      client_secret: @application.secret,
      email: @user.email,
      password: 'password'
    }
  end

  def query_token
    params = token_request_params
    post 'create', params: params
    JSON.parse(response.body)
  end

  def token_refresh_params(refresh_token)
    @user ||= Fabricate(:user)
    @application ||= Fabricate(:application)

    {
      grant_type: 'refresh_token',
      client_id: @application.uid,
      client_secret: @application.secret,
      email: @user.email,
      password: 'password',
      refresh_token: refresh_token
    }
  end

  def query_refresh_token(refresh_token)
    params = token_refresh_params refresh_token
    post 'create', params: params
    JSON.parse(response.body)
  end

  def create_user_params
    @user ||= Fabricate(:user)
    @application ||= Fabricate(:application)

    {
      password: 'password',
      email: @user.email,
      lastname: @user.lastname,
      firstname: @user.firstname,
      client_id: @application.uid
    }
  end
end
