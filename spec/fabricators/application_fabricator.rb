# frozen_string_literal: true

Fabricator(:application, from: Doorkeeper::Application) do
  name 'iOS client'
  redirect_uri ''
  scopes ''
end
