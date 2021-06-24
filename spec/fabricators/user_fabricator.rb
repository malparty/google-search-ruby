# frozen_string_literal: true

Fabricator(:user) do
  last_name FFaker::Name.last_name
  first_name FFaker::Name.first_name
  email FFaker::Internet.email
  password 'password123'
  password_confirmation 'password123'
end

Fabricator(:admin, from: :user) do
  is_admin true
end
