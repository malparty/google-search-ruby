# frozen_string_literal: true

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # Run authentication when needed
  config.before(:all, authenticated_user: true) do
    sign_in Fabricate(:user)
  end

  config.before(:each, authenticated_request_user: true) do
    sign_in Fabricate(:user)
  end

  config.before(:each, authenticated_api_user: true) do
    create_token_header
  end

  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  config.order = :random

  Kernel.srand config.seed
end
