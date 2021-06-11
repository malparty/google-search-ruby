# frozen_string_literal: true

module OAuthHelpers
  def token_request_params
    user = Fabricate(:user)
    application = Fabricate(:application)

    {
      grant_type: 'password',
      client_id: application.uid,
      client_secret: application.secret,
      email: user.email,
      password: 'password'
    }
  end
end
