# frozen_string_literal: true

Fabricator(:keyword) do
  name { FFaker::FreedomIpsum.word }
  user { Fabricate(:user) }
end
