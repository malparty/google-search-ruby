# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  context 'given a valid user' do
    it 'successfully connects' do
      user = Fabricate :user

      authenticate_cable user

      connect '/cable', headers: { 'X-USER-ID' => user.id }

      expect(connect.current_user.id).to eq user.id
    end
  end

  context 'given an unauthenticated user' do
    it 'rejects the connection' do
      authenticate_cable nil

      expect { connect '/cable', headers: { 'X-USER-ID' => 0 } }.to have_rejected_connection
    end
  end
end
