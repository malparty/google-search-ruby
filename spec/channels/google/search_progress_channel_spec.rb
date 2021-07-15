# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Google::SearchProgressChannel, type: :channel do
  it 'successfully subscribes' do
    stub_connection current_user: Fabricate(:user)

    subscribe

    expect(subscription).to be_confirmed
  end

  it 'successfully broadcasts a notification' do
    user = Fabricate :user
    stub_connection current_user: user

    subscribe

    expect { described_class.broadcast_to user, data: 'test' }.to have_broadcasted_to(user).with(data: 'test').exactly(:once)
  end
end
