# frozen_string_literal: true

require 'ffaker'

Fabricator(:user) do
  lastname FFaker::Name.last_name
  firstname FFaker::Name.first_name
  email FFaker::Internet.email
  password 'password123'
  password_confirmation 'password123'
end
