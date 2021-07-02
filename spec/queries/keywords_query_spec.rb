# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KeywordsQuery, type: :query do
  context 'given a user with no keywords' do
    it 'returns an empty collection' do
      result = described_class.new(Fabricate(:user)).call

      expect(result).to be_empty
    end
  end

  context 'given a user with 3 keywords' do
    it 'returns exactly 3 keywords' do
      user = Fabricate(:user)
      Fabricate.times(3, :keyword, user: user)

      result = described_class.new(user).call

      expect(result.count).to eq(3)
    end

    it 'orders the result by name ascending' do
      user = Fabricate(:user)

      %w[World awesome Pool].each { |name| Fabricate(:keyword, user: user, name: name) }

      result = described_class.new(user).call

      expect(result.map(&:name)).to eq(%w[awesome Pool World])
    end
  end

  context 'given many users with keywords' do
    it 'returns only keywords from the initialized user' do
      users = Fabricate.times(2, :user)
      Fabricate.times(10, :keyword, user: users[0])
      Fabricate.times(15, :keyword, user: users[1])

      result = described_class.new(users[0]).call

      expect(result.map(&:user_id)).to all(eq(users[0].id))
    end
  end
end
