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
      password: @user.password
    }
  end

  def query_token
    params = token_request_params

    post :create, params: params

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
      password: @user.password,
      refresh_token: refresh_token
    }
  end

  def query_refresh_token(refresh_token)
    params = token_refresh_params refresh_token

    post :create, params: params

    JSON.parse(response.body)
  end

  def create_user_params
    @user ||= Fabricate(:user)
    @application ||= Fabricate(:application)

    {
      password: @user.password,
      email: @user.email,
      last_name: @user.last_name,
      first_name: @user.first_name,
      client_id: @application.uid,
      client_secret: @application.secret
    }
  end

  def create_token_header(user)
    application = Fabricate(:application)
    access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)

    request.headers['Authorization'] = "Bearer #{access_token.token}"
  end
end
