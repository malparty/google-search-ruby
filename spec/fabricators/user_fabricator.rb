# frozen_string_literal: true

Fabricator(:user) do
  lastname 'DENT'
  firstname 'Arthur'
  email 'arthur@dent.com'
  password 'password'
  password_confirmation 'password'
end
